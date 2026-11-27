# Install on macOS (Apple Silicon)

A clean, reproducible Python environment on a Mac (Apple Silicon, macOS 15 or later), with
[`uv`](https://docs.astral.sh/uv/) as the package manager. `uv` provides its own managed
Python 3.12, so you never touch the system Python. Every step is idempotent — safe to
re-run after a macOS upgrade.

> [!TIP]
> Once the prerequisites (Steps 1–3) are done, `make install-all` does the rest:
> installs `uv`, pins Python 3.12, creates `.venv`, runs `uv sync --extra dev` and
> installs the git hooks. The Jupyter kernel (Step 5) stays manual.

## Step 1: Xcode Command Line Tools

They provide `make`, `git` and `clang` (the compiler is only needed if a package has no
arm64 wheel):

```sh
xcode-select --install
make --version           # GNU Make 3.81 — runs this repository's Makefile
```

## Step 2: Homebrew (for `git`, `direnv`, optional native libs)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

> [!NOTE]
> The two `shellenv` lines are what make `brew` available in new terminals.

## Step 3: Install `uv`

The standalone installer is self-updating and independent from Homebrew:

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
source "$HOME/.local/bin/env"      # or open a new terminal
uv --version
```

`make install-uv` covers both this route and `brew install uv`: it skips the installer as
soon as `uv` is on the `PATH`.

## Step 4: Clone and install

```sh
git clone git@github.com:heig-vd-ie/<your-project>.git
cd <your-project>
make install-all
make venv-activate
```

`make install-all` installs a managed CPython 3.12 (`~/.local/share/uv/python`, nothing
system-wide), writes `.python-version`, creates `.venv`, runs `uv sync --extra dev` and
installs the `nbstripout` + `pre-commit` git hooks.

## Step 5: Jupyter kernel (manual, optional)

```sh
source .venv/bin/activate
python -m ipykernel install --user --name=<your-project> --display-name "Python (<your-project>)"
```

`uv run jupyter lab` also works without activation and picks the project kernel
automatically. This is the one step that is not automatic, and the usual reason a notebook
starts with the wrong interpreter.

## Verify

```sh
make detect-env      # Detected: macOS (Darwin)
uv run python -V     # CPython 3.12.x, arm64
make test
```

## Daily commands

| Task | Command |
| :--- | :--- |
| Enter the environment | `source .venv/bin/activate` (zsh, keeps your prompt) or `make venv-activate` (bash subshell, `exit` to leave) |
| Run the tests | `make test` (or `make test file=tests/test_example.py`) |
| Run the lint & format hooks | `make check` |
| Build the wheel | `make build-wheel` |
| Rebuild from the lock | `uv sync --frozen --extra dev` |
| Remove the environment | `make uninstall-venv` |
| Update `uv` | `uv self update` (standalone) or `brew upgrade uv` |

## Notes & troubleshooting

- **`make venv-activate` shows `(.venv) bash-3.2$`** — expected: the target opens a bash
  subshell, and macOS ships no `~/.bashrc`, so bash keeps its default prompt. The venv *is*
  active. Leave with `exit` (not `deactivate`, which only unloads the venv). Prefer
  `source .venv/bin/activate` to keep your zsh prompt.
- **`uv: command not found`** — `source "$HOME/.local/bin/env"` or open a new terminal.
- **`command not found: brew`** — `eval "$(/opt/homebrew/bin/brew shellenv)"`.
- **Building a wheel fails** — install the toolchain (`xcode-select --install`); for
  `psycopg`, `brew install libpq`.
- **`code .` says command not found** — the `.dmg` does not add the CLI: in VS Code run
  ⌘⇧P → *Shell Command: Install 'code' command in PATH*, then `hash -r`.
- **`direnv`** (optional) — `brew install direnv`, add `eval "$(direnv hook zsh)"` to
  `~/.zshrc`, then `direnv allow` in the repo. `scripts/enable-direnv.sh` hooks bash, which
  is what the Makefile subshells use.

## References

- [Installing uv — standalone installer](https://docs.astral.sh/uv/getting-started/installation/)
- [Using uv with Jupyter](https://docs.astral.sh/uv/guides/integration/jupyter/)
