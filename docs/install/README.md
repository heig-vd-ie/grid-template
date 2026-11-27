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
