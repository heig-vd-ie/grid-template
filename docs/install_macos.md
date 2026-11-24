---
title: "Clean Python install on macOS (Apple Silicon)"
date: "2026-11-24"
version: "1.0"
ai_model: "DeepSeek V4.1 Flash (Mistral Hosted) &ndash; Mistral Vibe CLI"
---

# Clean Python install on macOS (Apple Silicon)

This setup gives a clean and reproducible Python environment on a Mac (Apple Silicon, macOS&nbsp;15 or later), with [`uv`](https://docs.astral.sh/uv/) as the package manager. Every step is idempotent&nbsp;&ndash; you can re-run it after a macOS upgrade without breaking anything.

> [!TIP]
> Shortcut: once Steps&nbsp;1, 2 and 4 are done (Command Line Tools, Homebrew, clone), `make install-all-macos` runs Steps&nbsp;3, 5, 6 and&nbsp;8 for you: `install-uv`, `install-python-uv`, then `venv-activate-and-uv-install` (`uv venv` when `.venv` is missing, `uv sync --extra dev`, `nbstripout`). Step&nbsp;7, the Jupyter kernel, stays manual. The commands below are kept so you know what happens under the hood and can debug a failure.

## Step 1: Xcode Command Line Tools

They provide `make`, `git` and `clang` (the last one is only needed if a package has no arm64 wheel and must compile):

```bash
xcode-select --install
xcode-select -p          # should print /Library/Developer/CommandLineTools
make --version           # GNU Make 3.81, which runs this repository's Makefile
```

<details>

<summary>Explanations</summary>

- `xcode-select --install`: opens the installer window for the Command Line Tools (a few minutes, no full Xcode needed).
- `xcode-select -p`: prints the active developer directory, a quick way to check the install succeeded.
- The GNU Make shipped by Apple is 3.81. It handles everything this repository uses (`.DEFAULT_GOAL`, `$(MAKEFILE_LIST)`, target-specific `SHELL`, `make target file=...`). `brew install make` only adds GNU Make&nbsp;4.x as `gmake` and is not required.

</details>

## Step 2: Homebrew

Homebrew provides `git`, `direnv` and the optional native libraries:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew --version
```

> [!NOTE]
> The two `shellenv` lines are what make `brew` available in new terminals. Without them, every new shell answers `command not found: brew`.

## Step 3: Install `uv`

The recommended route is the standalone installer from the [official uv documentation](https://docs.astral.sh/uv/getting-started/installation/#standalone-installer): it is self-updating and independent from Homebrew.

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source "$HOME/.local/bin/env"      # or simply open a new terminal
uv --version
```

- The binary lands in `~/.local/bin/uv`, next to a small `~/.local/bin/env` script.
- The installer appends `source $HOME/.local/bin/env` to `~/.zshrc` and `~/.zshenv`. Set `UV_NO_MODIFY_PATH=1` to keep it away from your dotfiles and add the `PATH` line yourself.
- Keep it up to date with `uv self update` (re-runs the installer, hence the same profile caveat).

<details>

<summary>Alternative with Homebrew</summary>

If you prefer to manage every tool with Homebrew:

```bash
brew install uv
brew upgrade uv      # `uv self update` is disabled for package-manager installs
```

Homebrew installs the binary in `/opt/homebrew/bin`, already on the `PATH`. `make install-uv` covers both routes: it skips the installer as soon as `uv` is on the `PATH`.

</details>

## Step 4: Clone the repository

```bash
mkdir -p ~/GitHub && cd ~/GitHub
git clone git@github.com:heig-vd-ie/working-memory.git
cd working-memory
```

<details>

<summary>SSH key not configured yet?</summary>

```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
cat ~/.ssh/id_ed25519.pub | pbcopy      # then paste it in GitHub &rarr; Settings &rarr; SSH keys
ssh -T git@github.com                   # should greet you by username
```

</details>

## Step 5: Managed Python 3.12

`pyproject.toml` requires `requires-python = ">=3.12,<3.14"`. Let `uv` provide an arm64 CPython instead of relying on the system one:

```bash
uv python install 3.12
uv python pin 3.12                    # writes .python-version, git-ignored here
uv python list --only-installed       # 3.12.x from ~/.local/share/uv/python
```

<details>

<summary>Explanations</summary>

- `uv python install 3.12`: downloads a managed CPython into `~/.local/share/uv/python/cpython-3.12-macos-aarch64-none`, nothing is installed system-wide.
- `uv python pin 3.12`: records the version in `.python-version`, which `uv venv`, `uv sync` and `uv run` read automatically.
- No PPA, no `pyenv`, no `sudo`: the same two commands work on WSL and Linux, which is why `make install-python-uv` wraps them.

</details>

## Step 6: Create `.venv` and install the dependencies

```bash
uv sync --extra dev
```

- It creates `.venv` (git-ignored) and installs the locked dependencies plus this project in editable mode, `dev` extra included (`black`, `mypy`, `pytest`).
- Add `--frozen` to *enforce* `uv.lock` (`uv sync --frozen --extra dev`): if `pyproject.toml` changed, the command fails instead of silently re-locking. Drop the flag when you do want to refresh the lock.
- `uv sync` also **prunes**: anything not listed in `uv.lock` is removed from `.venv`. Do not mix it with `uv pip install` (`make uv-install` is the documented escape hatch).

The equivalent make targets are `make _uv-venv` (optional, `uv sync` creates the venv itself) and `make uv-sync`.

## Step 7: Make the environment the default for Jupyter

```bash
source .venv/bin/activate
python -m ipykernel install --user --name=working-memory --display-name "Python (working-memory)"
jupyter lab
```

- The `ipykernel` line registers the venv as a Jupyter kernel, so JupyterLab, `nbconvert` and VS Code can all pick it by name. This is the one step that is not automatic, and the usual reason a notebook starts with the wrong interpreter.
- `uv run jupyter lab` also works without activation, and then the project kernel is used automatically.
- Leave the environment with `deactivate`, or `exit` if you entered it through `make venv-activate`.

> [!NOTE]
> **`source` or `make venv-activate`?** Both activate the same `.venv`, but they do not look the same:
>
> - `source .venv/bin/activate` runs in your current **zsh**: you keep your prompt, aliases and completion, and the prompt simply gains the `(.venv)` prefix.
> - `make venv-activate` opens a **new interactive bash&nbsp;3.2** subshell (the recipe forces `SHELL:=/bin/bash`), so the prompt falls back to `(.venv) bash-3.2$`. macOS ships no `~/.bashrc`, and a non-login `bash -i` reads nothing else, so bash keeps its compiled-in default prompt. It is cosmetic&nbsp;&ndash; the venv is active, `uv`, `pytest` and `make` all work inside it&nbsp;&ndash; and `exit` returns you to zsh.
> - `deactivate` is **not** the way out: it only removes the venv from that subshell and leaves you in `bash-3.2$`. Leave with `exit` (or `Ctrl-D`); if the prompt is still `bash-3.2` after one `exit`, you were nested&nbsp;&ndash; `exit` again, or run `exec zsh` to replace the shell and recover your prompt.
>
> Nothing is broken and nothing needs to be reinstalled: `make install-all-macos` created a healthy `.venv`, whichever way you enter it.

## Step 8: Git filters for this repository

```bash
uv run nbstripout --install        # same as make nbstripout-install
uv run pre-commit install          # optional, enables the isort/black/lint hooks
git config --local --get filter.nbstripout.clean
```

> [!NOTE]
> `nbstripout` writes into **this repository's** `.git/config` (never the global one), and stores the absolute path of `.venv/bin/python`. If you later move or delete `.venv`, re-run the target.

> [!CAUTION]
> The `pre-commit` hooks use `language: system`, so `isort`, `black` and `make lint` must be reachable: commit from a shell where `.venv` is active (`source .venv/bin/activate`, `make venv-activate`, or `direnv`). The `lint` hook calls the Poetry backend&nbsp;&ndash; use `make uv-lint` if you did not install Poetry.

## Step 9: `direnv` (optional, recommended)

```bash
brew install direnv
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
exec zsh
cd ~/GitHub/working-memory && direnv allow
```

`.envrc` exports `PYTHONPATH`, `GRB_LICENSE_FILE` and a Linux R path. Two macOS notes:

- `LD_LIBRARY_PATH=/usr/lib/R/lib` is a Linux path: drop it on macOS. If you load R through `brew install r`, use `DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix r)/lib/R"` instead.
- `scripts/enable-direnv.sh` only hooks **bash**, which is what the Makefile subshells use; the `~/.zshrc` hook above is the one that matters for your interactive shell.

## Step 10: Verify

```bash
make detect-env                    # Detected: macOS (Darwin)
uv run python -V                   # CPython 3.12.x, arm64, managed by uv
uv run pytest tests/ -v            # or: make uv-run-tests-py
uv run jupyter lab                 # optional: open notebooks/
```

## Daily use

| Task | Command |
| :--- | :--- |
| Enter the environment | `source .venv/bin/activate` (zsh: keeps your prompt) or `make venv-activate` (bash&nbsp;3.2 subshell, `exit` to leave) |
| Run the tests | `make uv-run-tests-py` (or `make uv-run-tests-py file=tests/test_example.py`) |
| Format | `make uv-format-py` |
| Lint | `make uv-lint` |
| Build the wheel | `make uv-build-wheel` |
| JupyterLab | `uv run jupyter lab` |
| Rebuild from the lock | `uv sync --frozen --extra dev` |
| Remove the environment | `make uninstall-venv` |
| Update `uv` | `uv self update` (standalone) or `brew upgrade uv` |

## Optional tools

```bash
brew install ffmpeg imagemagick     # export animations and images from the plotting notebooks
```

### VS Code: get `code` in the terminal

The `.dmg` installed from the website does **not** put `code` on the `PATH` (the Linux `.deb` does it for you), so `code .` answers `command not found`. Enable it once, from VS Code:

1. ⌘⇧P (Command Palette) &rarr; *Shell Command: Install 'code' command in PATH*
2. Restart the terminal, or run `hash -r` in the current zsh, because zsh caches command paths

```zsh
which code        # /usr/local/bin/code
code --version
code .            # opens the current folder, like on Linux
```

<details>

<summary>Explanations</summary>

- The palette command creates the symlink `/usr/local/bin/code` &rarr; `/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code`, the CLI embedded in the app bundle. `/usr/local/bin` is already on the macOS `PATH`, so nothing else has to be configured.
- `make install-vscode-extensions` and `make freeze-vscode-extensions` call `code --install-extension` and `code --list-extensions`, so they need this command to exist.
- If the palette command fails with a permission error (`/usr/local/bin` not writable), create the link yourself, then clear the cache:

```zsh
sudo ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code
hash -r
which code
```

- Without `sudo`, an alias in `~/.zshrc` does the same job: `alias code="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"`.
- The link points at `/Applications`: if you move VS Code elsewhere (`~/Applications`, external volume), re-run the palette command or adapt the path.

</details>

With the command available, the repository targets work:

```zsh
make install-vscode-extensions   # installs the list from .vscode/extensions.txt
code --list-extensions           # check what is installed (make freeze-vscode-extensions refreshes the list)
```

## Troubleshooting

| Symptom | Fix |
| :--- | :--- |
| `uv: command not found` | `source "$HOME/.local/bin/env"` or open a new terminal; check `echo $PATH` contains `~/.local/bin` |
| `command not found: brew` | `eval "$(/opt/homebrew/bin/brew shellenv)"`, and add it to `~/.zprofile` |
| `error: A virtual environment already exists at: .venv` | only `make _uv-venv` (a bare `uv venv`) raises it: `make install-all-macos` and `uv sync` reuse the existing `.venv`; `make uninstall-venv` rebuilds from scratch |
| `note: Building wheel for ... failed` | install the compiler toolchain (`xcode-select --install`); for `psycopg`, `brew install libpq` |
| Notebook starts with the wrong Python | redo Step&nbsp;7 inside the activated `.venv`, then pick the `working-memory` kernel |
| `make lint` / `make format-py` fails | they use the Poetry backend, which is not installed by the macOS flow: use `make uv-lint` and `make uv-format-py` |
| `make install-all-poetry` | not supported on macOS, the uv route is the supported one |
| The prompt turns into `(.venv) bash-3.2$` | expected after `make venv-activate`: that target opens bash&nbsp;3.2, and with no `~/.bashrc` on macOS it keeps bash's default prompt. Leave with `exit`&nbsp;&ndash; `deactivate` only unloads the venv, it does not leave bash. Still `bash-3.2` after one `exit`? You were nested: `exit` again or `exec zsh`. To avoid it altogether, use `source .venv/bin/activate` |
| `code .` answers `command not found` | the `.dmg` does not install the CLI: ⌘⇧P &rarr; *Shell Command: Install 'code' command in PATH*, then `hash -r`. See [VS Code](#vs-code-get-code-in-the-terminal) |

## References

- [Installing uv &ndash; standalone installer](https://docs.astral.sh/uv/getting-started/installation/#standalone-installer) and [Homebrew](https://docs.astral.sh/uv/getting-started/installation/#homebrew)
- [Using uv with Jupyter](https://docs.astral.sh/uv/guides/integration/jupyter/)
- [handson-mlp INSTALL.md](https://github.com/ageron/handson-mlp/blob/main/INSTALL.md) &ndash; source of the `uv sync` + `ipykernel install` pattern used in Steps&nbsp;6 and&nbsp;7
- WSL and Linux equivalent: [install_poetry.md](install_poetry.md), [install_wsl.md](install_wsl.md)
