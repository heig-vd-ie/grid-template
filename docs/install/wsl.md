# Install on WSL (Windows)

WSL behaves like Linux for this project. `uv` provides its own managed Python 3.12, so no
`deadsnakes` PPA and no system Python are needed. `make detect-env` prints
`Detected: WSL environment` (it reads `/proc/version`).

## 1. Prerequisites

Inside your WSL distribution (Ubuntu by default):

```sh
sudo apt update
sudo apt install -y make git curl
```

Only if a dependency has to compile native code (for example `psycopg`):

```sh
make install-system-deps     # libpq-dev gcc python3-dev build-essential direnv
```

## 2. Clone

Clone **inside the Linux filesystem** (e.g. `~/projects`), not under `/mnt/c/...` — the
Windows mount is much slower and breaks file permissions and git hooks.

```sh
cd ~ && mkdir -p projects && cd projects
git clone git@github.com:heig-vd-ie/<your-project>.git
cd <your-project>
```

## 3. Install

```sh
make install-all
make venv-activate
```

`make install-all` installs `uv`, pins Python 3.12, creates `.venv`, runs
`uv sync --extra dev` and installs the git hooks (`nbstripout` + `pre-commit`).
If `uv` was just installed, open a new terminal (or `source ~/.bashrc`) so it is on your
`PATH`, then re-run.

## 4. Verify

```sh
make detect-env      # Detected: WSL environment
make test
```

## Notes

- Open the repo in VS Code with `code .` — the WSL extension runs the editor against the
  Linux side, so `make`, `uv` and the venv all resolve correctly.
- Leave the environment entered with `make venv-activate` using `exit`.
- If you delete `.venv`, run `make install-all` again to rebuild it.
