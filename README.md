# Grid-Template (Replace the name)

Author: Mohammad Rayati (Replace the name)

---

## Overview (Replace this section)

Describe your project here:  
- What does it do?  
- Why does it exist?  
- Who is it for?  
- What problem does it solve?  

This repository provides a clean starting point with standard tooling for Python-based research and development projects at the Institute of Energies (Power Systems Group).  

---

## Project Features (Replace this section)

- Standardized project structure  
- Makefile automation for development workflows  
- Virtual environment setup and dependency management  
- Environment-variable handling  
- Predefined folder structure for `src`, `tests`, `docs`, `scripts`, `experiments`, and `data`  
- Optional integration with recommended Git & Python best practices  
- Zero magic, zero surprises (well almost)

---

## How to Run (Replace this section)

1. Click **“Use this template”** on the GitHub page.  
2. Select **“Create new repository”**, name your project, and choose where to host it.  
3. Clone your new repository locally.

---

## Installation & Setup (Replace this section)

1. Install `make` (if not already installed): 
```sh
    sudo apt update
    sudo apt install make
```

2. Initialize the project and create the virtual environment: 
```sh
    make install-all # if something fails, try to debug, if not working, raise an issue or contact someone
    make venv-activate
```

3. If you delete your `.venv`, you can run `make install-all` to install everything from beginning.

For recommended Git and Python best practices, refer to [here](docs/best_practices.md).

---

## Remarks

This template currently works on Linux-based systems (including WSL).
On macOS, some Makefile targets may not work.
To see all available Makefile commands, simply run: 
```sh
    make
```
Or open the Makefile directly to see what’s going on under the hood.
