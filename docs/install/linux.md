# Install on Linux

Tested on Debian/Ubuntu. `uv` provides its own managed Python 3.12, so no `deadsnakes`
PPA and no system Python are needed.

## 1. Prerequisites

```sh
sudo apt update
sudo apt install -y make git curl
```

Only if a dependency has to compile native code (for example `psycopg`), install the
build libraries too:

```sh
make install-system-deps     # libpq-dev gcc python3-dev build-essential direnv
```

## 2. Clone

```sh
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
make detect-env      # Detected: Native Linux environment
make test
```

## Notes

- Leave the environment entered with `make venv-activate` using `exit`.
- `.envrc` + `direnv` activate the venv automatically when you `cd` into the repo.
  Install `direnv` (`sudo apt install direnv`, hook it in your `~/.bashrc`), then run
  `direnv allow` once.
- If you delete `.venv`, run `make install-all` again to rebuild it.
