# PSRL-Template (Replace the name)

Author: Mohammad Rayati (Replace the name)

---

## Overview (Replace this section)

Describe your project here:  
- What does it do?  
- Why does it exist?  
- Who is it for?  
- What problem does it solve?  

This repository provides a clean starting point with standard tooling for Python-based research and development projects at the Institute of Energies (Power Systems Research Laboratory).  

---

## Project Features (Replace this section)

- Standardized project structure  
- Makefile automation for development workflows  
- Virtual environment setup and dependency management  
- Environment-variable handling  
- Predefined folder structure for `src`, `tests`, `docs`, and `scripts`  
- Optional integration with recommended Git & Python best practices  
- Zero magic, zero surprises (well almost)

---

## How to Run (Replace this section)

1. Click **“Use this template”** on the GitHub page.  
2. Select **“Create new repository”**, name your project, and choose where to host it.  
3. Clone your new repository locally.

On the first push, a one-time workflow fills in your project name and author, resets the changelog, strips this template scaffolding, removes the group reference docs (`docs/best-practices/`, the install guides stay), and then removes itself.

---

## Installation & Setup (Replace this section)

The same `make install-all` works on macOS, Linux and WSL. For per-OS prerequisites and
notes, see [`docs/install/`](docs/install/README.md).

1. Install `make` if you don't have it:
   - **Linux / WSL:** `sudo apt update && sudo apt install make`
   - **macOS:** `xcode-select --install` (ships `make`, `git` and `clang`)

2. Install everything and create the virtual environment — the same command on macOS, Linux and WSL:
```sh
    make install-all
    make venv-activate
```
`make install-all` installs `uv`, a managed Python 3.12, the dependencies and the git hooks. If it fails, debug it, or raise an issue / contact someone.

3. If you delete your `.venv`, run `make install-all` again to rebuild it.

### Common commands

| Task | Command |
| :--- | :--- |
| Enter the environment | `make venv-activate` (`exit` to leave) |
| Run the tests | `make test` (or `make test file=tests/test_example.py`) |
| Run the lint & format hooks | `make check` |
| Build the wheel | `make build-wheel` |
| List every command | `make` |

Pre-commit hooks and CI are covered in [`docs/install/`](docs/install/README.md#pre-commit-hooks--ci).

For recommended Git and Python best practices, refer to [here](docs/best-practices/README.md).
