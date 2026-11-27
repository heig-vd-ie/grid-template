# Common Makefile — uv-only workflow.
# Works the same on macOS, Linux and WSL: uv provides Python on all three.

PYTHON_VERSION := 3.12
VENV_DIR       := .venv
ORG            := heig-vd-ie

UNAME_S := $(shell uname -s)

.DEFAULT_GOAL := help

# ---------------------------------------------------------------------------
# Help & environment
# ---------------------------------------------------------------------------

help: ## Show this help message
	@echo "Available targets:"
	@grep -hE '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-26s\033[0m %s\n", $$1, $$2}'

detect-env: ## Detect macOS, WSL or native Linux
	@if [ "$(UNAME_S)" = "Darwin" ]; then \
		echo "Detected: macOS (Darwin)"; \
	elif grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then \
		echo "Detected: WSL environment"; \
	else \
		echo "Detected: Native Linux environment"; \
	fi

# ---------------------------------------------------------------------------
# Setup — one entry point for macOS, Linux and WSL
# ---------------------------------------------------------------------------

install-all: ## Install uv + Python, create the venv, sync deps and git hooks
	@$(MAKE) detect-env
	@$(MAKE) install-uv
	@$(MAKE) install-python
	@$(MAKE) venv
	@. $(VENV_DIR)/bin/activate && $(MAKE) sync && $(MAKE) install-hooks
	@echo ""
	@echo "Done. Enter the environment with 'make venv-activate'."
	@echo "On macOS, also register the Jupyter kernel (see docs/install_macos.md)."

install-uv: ## Install uv if it is not already available
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "Installing uv..."; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
	else \
		echo "uv already installed: $$(uv --version)"; \
	fi

install-python: ## Install and pin Python $(PYTHON_VERSION) via uv
	@command -v uv >/dev/null 2>&1 || { echo "uv is not installed. Run 'make install-uv' first."; exit 1; }
	uv python install $(PYTHON_VERSION)
	uv python pin $(PYTHON_VERSION)

install-system-deps: ## Optional apt libraries for building native wheels (Linux/WSL)
	@read -p "Install libpq-dev gcc python3-dev build-essential direnv via apt? [y/N] " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		sudo apt update && sudo apt install -y libpq-dev gcc python3-dev build-essential direnv; \
	else \
		echo "Skipped."; \
	fi

# ---------------------------------------------------------------------------
# Virtual environment & dependencies
# ---------------------------------------------------------------------------

venv: ## Create the virtual environment with uv if it is missing
	@command -v uv >/dev/null 2>&1 || { echo "uv is not installed. Run 'make install-uv' first."; exit 1; }
	@test -d $(VENV_DIR) || uv venv $(VENV_DIR) --python $(PYTHON_VERSION)

sync: ## Sync dependencies from uv.lock (dev extra included)
	@command -v uv >/dev/null 2>&1 || { echo "uv is not installed. Run 'make install-uv' first."; exit 1; }
	uv sync --extra dev

venv-activate: SHELL:=/bin/bash
venv-activate: ## Enter the virtual environment in an interactive subshell
	@test -d $(VENV_DIR) || $(MAKE) venv
	@bash --rcfile <(echo '. ~/.bashrc 2>/dev/null; . $(VENV_DIR)/bin/activate; echo "venv activated — type exit to leave."; . scripts/enable-direnv.sh') -i

uninstall-venv: ## Remove the virtual environment
	rm -rf $(VENV_DIR)
	@echo "Removed $(VENV_DIR)."

# ---------------------------------------------------------------------------
# Git hooks (nbstripout filter + pre-commit)
# ---------------------------------------------------------------------------

install-hooks: ## Install the nbstripout filter and the pre-commit git hook
	uv run nbstripout --install
	uv run pre-commit install

# ---------------------------------------------------------------------------
# Development
# ---------------------------------------------------------------------------

test: ## [file=...] Run the tests with uv (optionally a single file)
	@if [ -n "$(file)" ]; then \
		PYTHONWARNINGS=ignore uv run pytest "$(file)" -v; \
	else \
		PYTHONWARNINGS=ignore uv run pytest tests/ -v; \
	fi

check: ## Run all pre-commit hooks (isort, black, pylint) on every file
	uv run pre-commit run --all-files

build-wheel: ## Build the project wheel with uv
	uv build --wheel

fetch-wheel: ## Fetch a wheel from a remote repo [REPO=.. BRANCH=.. VERSION=.. DEST_DIR=..]
	@bash scripts/fetch-wheel.sh $(ORG) $(REPO) $(BRANCH) $(VERSION) $(DEST_DIR)

# ---------------------------------------------------------------------------
# VS Code
# ---------------------------------------------------------------------------

install-vscode-extensions: ## Install VS Code extensions from .vscode/extensions.txt
	@xargs -n 1 code --install-extension < .vscode/extensions.txt

freeze-vscode-extensions: ## Save installed VS Code extensions to .vscode/extensions.txt
	@code --list-extensions > .vscode/extensions.txt
