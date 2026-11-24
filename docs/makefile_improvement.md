# Makefile Improvements and `uv` Support

- **Date**: 2026-08-24
- **Update**: 2026-11-24 (applied macOS targets in `Makefile.common.mak` + pointer to `install_macos.md`)
- **AI Models**: 
  * Gemini 3.5 Flash-light (Extended Thinking)
  * Gemini 3.6 Flight (Extended Thinking)
  * Gemini 3.1 Pro (Extended Thinking)
  * GLM-5.3 (Mistral Hosted)[max] (audit and Apple Silicon section, 2026-11-09)
  * DeepSeek V4.1 Flash (Mistral Hosted) &ndash; Mistral Vibe CLI (macOS install notes and Makefile review, 2026-11-24)

---

Here is the updated `Makefile` with `uv` support added alongside all existing `poetry` workflows:

```makefile
# Common Makefile

PYTHON_VERSION := 3.12
VENV_DIR := .venv
ORG := heig-vd-ie

# Default target: help
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "Available targets:"
	@grep -hE '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-42s\033[0m %s\n", $$1, $$2}'

detect-env: ## Detect whether running in WSL or native Linux
	@if grep -qEi "(Microsoft|WSL)" /proc/version; then \
		echo "Detected: WSL environment"; \
	else \
		echo "Detected: Native Linux environment"; \
	fi

install-pipx: ## Install pipx (Python packaging tool)
	@read -p "This will install pipx and its dependencies. Continue? [y/N] " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		sudo apt update; \
		sudo apt install -y pipx; \
		pipx ensurepath --force; \
	else \
		echo "Skipped installing dependencies."; \
	fi

install-python-wsl: ## Install Python $(PYTHON_VERSION) and venv support on WSL
	@echo "Checking if Python $(PYTHON_VERSION) is installed..."
	@if ! command -v python$(PYTHON_VERSION) >/dev/null 2>&1; then \
		echo "Installing Python $(PYTHON_VERSION)..."; \
		sudo add-apt-repository -y ppa:deadsnakes/ppa; \
		sudo apt update; \
		sudo apt install -y python$(PYTHON_VERSION) python$(PYTHON_VERSION)-venv; \
	else \
		echo "Python $(PYTHON_VERSION) already installed"; \
	fi

install-poetry: ## Install Poetry using pipx
	@echo "Installing Poetry..."
	pipx install poetry

install-uv: ## Install uv using pipx
	@echo "Installing uv..."
	pipx install uv

install-deps: ## Install system dependencies
	@echo "Installing system dependencies..."
	@read -p "This will install system dependencies (libpq-dev gcc python3-dev build-essential direnv). Continue? [y/N] " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		sudo apt update; \
		sudo apt install -y libpq-dev gcc python3-dev build-essential direnv; \
	else \
		echo "Skipped installing dependencies."; \
	fi

# ------------------------------------------------------------------------------
# VIRTUAL ENVIRONMENT & POETRY TARGETS
# ------------------------------------------------------------------------------

_venv: ## Create a virtual environment using standard venv
	@echo "Creating virtual environment with Python $(PYTHON_VERSION)..."
	python$(PYTHON_VERSION) -m venv .venv

venv-activate: SHELL:=/bin/bash
venv-activate: ## Enter venv in a subshell
	@test -d .venv || make _venv
	@bash --rcfile <(echo '. ~/.bashrc; . .venv/bin/activate; echo "You are now in a subshell with venv activated."; . scripts/enable-direnv.sh') -i

poetry-use: ## Tell Poetry to use local venv
	@echo "Configuring Poetry to use .venv..."
	poetry env use .venv/bin/python$(PYTHON_VERSION)

poetry-install: ## Install dependencies using Poetry
	@echo "Installing Python packages using Poetry..."
	@poetry install --extras "internal" || ( \
		echo "⚠️ If psycopg-c installation fails, see:"; \
		echo "https://stackoverflow.com/questions/77727508/problem-installing-psycopg2-for-python-venv-through-poetry"; \
		echo "Error hint: _psycopg-c may not support PEP 517 builds or may be missing system dependencies."; \
		exit 1 \
	)

venv-activate-and-poetry-use-install: SHELL:=/bin/bash
venv-activate-and-poetry-use-install: ## Activate venv and install packages via Poetry
	@echo "Activating virtual environment and installing packages with Poetry..."
	@test -d .venv || make _venv
	@rm -f poetry.lock || true
	@bash --rcfile <(echo '. ~/.bashrc; . .venv/bin/activate; echo "You are now in a subshell with venv activated."; make poetry-use; make poetry-install; make nbstripout-install; . scripts/enable-direnv.sh') -i

# ------------------------------------------------------------------------------
# UV TARGETS
# ------------------------------------------------------------------------------

_venv-uv: ## Create virtual environment fast using uv
	@echo "Creating virtual environment with uv (Python $(PYTHON_VERSION))..."
	uv venv $(VENV_DIR) --python $(PYTHON_VERSION)

uv-sync: ## Install/Sync dependencies fast using uv
	@echo "Syncing Python packages using uv..."
	uv sync --extra "internal"

uv-install: ## Alternative editable install via uv pip
	@echo "Installing editable package with extra dependencies via uv pip..."
	uv pip install -e ".[internal]"

venv-activate-and-uv-sync: SHELL:=/bin/bash
venv-activate-and-uv-sync: ## Activate venv and sync packages using uv
	@echo "Activating virtual environment and syncing packages with uv..."
	@test -d .venv || make _venv-uv
	@bash --rcfile <(echo '. ~/.bashrc; . .venv/bin/activate; echo "You are now in a subshell with venv activated."; make uv-sync; make nbstripout-install; . scripts/enable-direnv.sh') -i

uv-run-tests-py: ## Run tests using uv run pytest
	@echo "Running Python tests with uv..."
	@if [ -n "$(file)" ]; then \
		PYTHONWARNINGS=ignore uv run pytest "$(file)" -v; \
	else \
		PYTHONWARNINGS=ignore uv run pytest tests/ -v; \
	fi

uv-format-py: ## Format Python code with black using uv
	@echo "Formatting Python code with black via uv..."
	@uv run black .

uv-lint: ## Lint code with pylint using uv
	@echo "Linting Python code with pylint via uv..."
	@uv run pylint --rcfile .pylintrc **/*.py

uv-build-wheel: ## Build wheel package using uv
	@echo "Building Python wheel with uv..."
	@uv build --wheel

# ------------------------------------------------------------------------------
# COMMON & TOOLING TARGETS
# ------------------------------------------------------------------------------

install-vscode-extensions: ## Install Visual Studio Code extensions
	@echo "Installing Visual Studio Code extensions..."
	@xargs -n 1 code --install-extension < .vscode/extensions.txt 

freeze-vscode-extensions: ## Update Visual Studio Code extensions list
	@echo "Freezing Visual Studio Code extensions..."
	@code --list-extensions > .vscode/extensions.txt

install-all: ## Install all dependencies and set up environment (Poetry backend)
	@$(MAKE) install-pipx
	@$(MAKE) install-python-wsl
	@$(MAKE) install-poetry
	@$(MAKE) install-deps
	@$(MAKE) _venv
	@$(MAKE) venv-activate-and-poetry-use-install
	@echo "All dependencies installed successfully (Poetry)!"

install-all-uv: ## Install all dependencies and set up environment (uv backend)
	@$(MAKE) install-pipx
	@$(MAKE) install-python-wsl
	@$(MAKE) install-uv
	@$(MAKE) install-deps
	@$(MAKE) _venv-uv
	@$(MAKE) venv-activate-and-uv-sync
	@echo "All dependencies installed successfully (uv)!"

uninstall-venv: ## Uninstall the virtual environment
	@echo "Uninstalling virtual environment..."
	rm -rf $(VENV_DIR)
	@echo "Virtual environment uninstalled."

run-tests-py: ## [file] Run tests using pytest
	@echo "Running Python tests..."
	@if [ -n "$(file)" ]; then \
		PYTHONWARNINGS=ignore $(VENV_DIR)/bin/python -m pytest "$(file)" -v; \
	else \
		PYTHONWARNINGS=ignore $(VENV_DIR)/bin/python -m pytest tests/ -v;\
	fi

format-py: ## Format Python code using black
	@echo "Formatting Python code with black..."
	@poetry run black .

build-wheel: ## Build the Python wheel using Poetry
	@echo "Building Python wheel..."
	@poetry build -f wheel

fetch-wheel: ## Fetch the Python wheel from a remote URL
	@echo "Fetching Python wheel..."
	@bash scripts/fetch-wheel.sh $(ORG) $(REPO) $(BRANCH) $(VERSION) $(DEST_DIR)

lint: ## Lint the code using pylint
	@echo "Linting Python code with pylint..."
	@poetry run pylint --rcfile .pylintrc **/*.py

nbstripout-install:
	@echo "Installing nbstripout git filter..."
	nbstripout --install

```

### Key Additions Summary

* **`install-uv`**: Installs `uv` globally via `pipx`.
* **`_venv-uv`**: Creates the `.venv` directory using `uv venv` (significantly faster than standard `python -m venv`).
* **`uv-sync` / `uv-install**`: Synchronizes or installs `pyproject.toml` dependencies with `--extra "internal"`.
* **`uv-run-tests-py` / `uv-format-py` / `uv-lint**`: Executes tools directly through `uv run` without requiring manual virtual environment activation.
* **`install-all-uv`**: An alternative one-command setup using `uv` instead of Poetry.

---

## Audit: this recap vs the current `Makefile.common.mak` (2026-11-09)

The deployed `Makefile.common.mak` has moved on since this recap was written. Target-by-target verdict, for installing with WSL, uv on Linux or Windows:

| Item | This recap (2026-08-24) | Current `Makefile.common.mak` | Verdict |
| :--- | :--- | :--- | :--- |
| `install-uv` | `pipx install uv` (requires apt + pipx first) | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | **Current wins**: official installer, no pipx chain, and the same command works on macOS; it is what installed `~/.local/bin/uv` on this machine |
| `_venv-uv` vs `_uv-venv` | no guard | `command -v uv` guard with a hint | **Current wins** |
| `uv-sync` extras | `--extra "internal"` | `--extra dev` | **Current wins here**: this repo's `pyproject.toml` defines only `dev` (black, mypy, pytest); `internal` belongs to the heig-vd-ie template |
| venv + install flow | interactive subshell only | adds non-interactive `venv-activate-and-uv-install` | **Current wins** for scripts and CI; keep the interactive variant for humans |
| `uv-run-tests-py`, `uv-format-py`, `uv-lint`, `uv-build-wheel` | present | missing | **Recap wins**: `uv run` needs no venv activation; add these targets |
| `install-python-wsl` | deadsnakes PPA | deadsnakes PPA (+ tutorial link) | **Both obsolete for uv**: `uv python install` provides CPython on WSL, Linux, macOS and Windows alike - no PPA needed |
| `detect-env` | `/proc/version` grep | same | **Both Linux-only**: on macOS `/proc/version` does not exist, so the target falsely reports "Native Linux" |
| `install-all*` naming | Poetry default, uv alternative | uv default, Poetry alternative | Current matches the uv-first strategy |

**Conclusion**: neither file is strictly better. The current Makefile is stronger on installation robustness and is correct for this repo's extras; this recap is stronger on `uv run` tooling. The sections below merge the two and add the Apple Silicon path.

> [!NOTE]
> `pylint` is not in the `dev` extra (only black, mypy, pytest), so both the recap's `uv-lint` and the current `lint` assume an ad-hoc install. Either add pylint to `pyproject.toml`, or run it ephemerally: `uv run --with pylint pylint --rcfile .pylintrc .`

## Proposed merged targets (uv-first, cross-platform)

```makefile
# --- OS detection: Linux / WSL / macOS ---
UNAME_S := $(shell uname -s)

detect-env: ## Detect WSL, native Linux or macOS
	@if [ "$(UNAME_S)" = "Darwin" ]; then \
		echo "Detected: macOS (Darwin)"; \
	elif grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then \
		echo "Detected: WSL environment"; \
	else \
		echo "Detected: Native Linux environment"; \
	fi

# --- Python through uv: replaces the deadsnakes PPA on every OS ---
install-python-uv: ## Install and pin Python $(PYTHON_VERSION) via uv (WSL, Linux, macOS)
	@command -v uv >/dev/null 2>&1 || (echo "uv is not installed. Run 'make install-uv' first."; exit 1)
	uv python install $(PYTHON_VERSION)
	uv python pin $(PYTHON_VERSION)    # writes .python-version, used by uv venv/sync/run

# --- uv run tooling: no venv activation needed ---
uv-run-tests-py: ## [file] Run tests using uv run pytest
	@if [ -n "$(file)" ]; then \
		PYTHONWARNINGS=ignore uv run pytest "$(file)" -v; \
	else \
		PYTHONWARNINGS=ignore uv run pytest tests/ -v; \
	fi

uv-format-py: ## Format Python code with black using uv
	uv run black .

uv-lint: ## Lint code with pylint using uv
	uv run pylint --rcfile .pylintrc **/*.py

uv-build-wheel: ## Build the Python wheel using uv
	uv build --wheel
```

Notes:

- `uv venv` already auto-downloads a managed CPython when no matching interpreter is found; `install-python-uv` just makes it explicit and pins the version (this repo has no `.python-version` yet).
- `uv run` re-syncs the environment from `uv.lock` before running, so tests, formatting and builds always run against the locked dependencies.

## Apple Silicon (M4 Pro): uv only, with make

One-time prerequisites on the Mac:

```bash
xcode-select --install        # provides GNU Make, clang, git
# optional, via Homebrew:
# brew install make direnv    # GNU Make 4.x as gmake, direnv
```

Then the setup is four targets, all already cross-platform:

```bash
make install-uv                     # astral.sh installer: works on macOS as-is
make install-python-uv              # uv-managed CPython 3.12 (arm64), no PPA equivalent needed
make _uv-venv                      # uv venv .venv --python 3.12
make venv-activate-and-uv-install   # non-interactive: uv sync + nbstripout
```

Or the one-shot target, applied to `Makefile.common.mak` on 2026-11-24:

```makefile
install-all-macos: ## Install everything on Apple Silicon (uv only)
	@$(MAKE) install-uv
	@$(MAKE) install-python-uv
	@$(MAKE) _uv-venv
	@$(MAKE) venv-activate-and-uv-install
	@echo "Setup complete on macOS (uv)!"
```

> [!NOTE]
> The applied target drops the explicit `make _uv-venv` line, because `venv-activate-and-uv-install` already creates the venv when it is missing. `make install-all-macos` can therefore be re-run on a repository that already has a `.venv`&nbsp;&ndash; a bare `uv venv` refuses an existing environment.
>
> The complete procedure, from the Xcode Command Line Tools to the Jupyter kernel, is in [install_macos.md](install_macos.md).

macOS caveats:

- **make**: the GNU Make bundled with the Xcode Command Line Tools (3.81 on every macOS to date) runs this Makefile as-is - `.DEFAULT_GOAL`, `SHELL :=`, `$(MAKEFILE_LIST)` and `make ... file=...` are all supported. `brew install make` only brings 4.x, as `gmake`.
- **bash**: the `venv-activate*` targets force `SHELL:=/bin/bash`, which is bash 3.2 on macOS; process substitution `<(...)` and `read -p` both work in it. The zsh login shell is irrelevant to these targets, but that is also why the interactive subshell shows the bare `(.venv) bash-3.2$` prompt: macOS ships no `~/.bashrc`, and a non-login `bash -i` reads nothing else, so bash keeps its compiled-in default prompt. Cosmetic only&nbsp;&ndash; the venv is active, and `source .venv/bin/activate` from zsh keeps the normal prompt. See [install_macos.md](install_macos.md#step-7-make-the-environment-the-default-for-jupyter).
- **system packages**: `install-deps` (apt) does not apply on macOS. A pure-uv workflow needs nothing system-wide - arm64 wheels are prebuilt. If a package must compile from source: `brew install libpq` (psycopg), etc.
- **direnv**: `brew install direnv`, hook it into zsh (`eval "$(direnv hook zsh)"` in `~/.zshrc`), then `direnv allow` once in the repo. The repo's `scripts/enable-direnv.sh` hooks bash only, which is fine for the Makefile subshells.
- **`.envrc`**: `LD_LIBRARY_PATH=/usr/lib/R/lib` is a Linux path. On macOS, Homebrew R lives under `/opt/homebrew/lib/R` and the variable is `DYLD_FALLBACK_LIBRARY_PATH`. `PYTHONPATH` and `GRB_LICENSE_FILE` work unchanged.
- **scripts**: `scripts/*.sh` contain no GNU-only constructs (no `sed -i` without suffix, no `readlink -f`, no `md5sum`) - portable as-is.
- **Windows native**: uv itself installs (`irm https://astral.sh/uv/install.ps1 | iex`) and `uv python install` works, but this Makefile needs GNU make + bash: keep using WSL on Windows - the `install-python-wsl` path stays for that.