# Installing the project

`make install-all` sets the project up the same way on every platform: it installs
[`uv`](https://docs.astral.sh/uv/), a managed Python 3.12, the dependencies and the git
hooks. Pick your OS for the prerequisites and the platform-specific notes:

- [macOS (Apple Silicon)](macos.md)
- [Linux](linux.md)
- [WSL (Windows)](wsl.md)

Once the setup is done, the day-to-day commands are identical everywhere:

| Task | Command |
| :--- | :--- |
| Enter the environment | `make venv-activate` (`exit` to leave) |
| Run the tests | `make test` (or `make test file=tests/test_example.py`) |
| Run the lint & format hooks | `make check` |
| Build the wheel | `make build-wheel` |
| Remove the environment | `make uninstall-venv` |
| List every command | `make` |

## Pre-commit hooks & CI

**Pre-commit** runs `isort`, `black` and `pylint` locally on the files you stage,
before each commit. **CI** (GitHub Actions) runs the test suite with `pytest` on
Ubuntu and macOS on every push and pull request. Configs: `.pre-commit-config.yaml`,
`.github/workflows/ci.yml`.

### Pre-commit (local)

| Task | Command |
| :--- | :--- |
| Activate the hooks | `make install-hooks` (also run by `make install-all`) |
| Run the hooks manually on all files | `make check` |
| Skip the hooks for **one** commit | `git commit --no-verify` |
| Deactivate the hooks completely | `uv run pre-commit uninstall` |

Re-activate any time with `make install-hooks`. The hooks also update when you edit
`.pre-commit-config.yaml` — rerun `make check` to apply the new config.

### CI (GitHub Actions)

CI runs automatically on GitHub; there is nothing to activate locally. To change or
disable it, edit `.github/workflows/ci.yml`:

- **Disable entirely:** delete the file, or rename it to `ci.yml.disabled`.
- **Run on fewer events:** narrow the `on:` line (e.g. `on: [pull_request]`).
- **Drop an OS:** remove it from the `matrix.os` list.
