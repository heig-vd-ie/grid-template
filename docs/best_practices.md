
<h1 align="center">
    <br>
    Git & Python Best Practices
    <img src="https://www.vectorlogo.zone/logos/python/python-icon.svg" alt="Python" width="40" height="40">
    &nbsp;
    <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="Git" width="40" height="40">
</h1>

## Git commands

- [x] Quick start: skim the cheat-sheet in [here](git_commands.md) for the essentials. If curiosity (or FOMO) strikes, dive into the full deep‑dive: [here](REP_Course_GitGitlab_v1-1-2.pdf).

## Pull Requests

- [x] Why do we need it? https://www.hackerone.com/blog/why-you-should-use-pull-requests-developers-essential-tool
- [x] How to do that? See https://www.youtube.com/watch?v=nCKdihvneS0.
- [x] Write clear commit messages ([how-to](https://www.conventionalcommits.org/en/v1.0.0/))
- [x] Commit small, focused changes often
- [x] Always add unit tests for new code (test-driven development -> [guide](https://medium.com/@muirujackson/python-test-driven-development-6235c479baa2))

---

## Repository Organization

- [x] README.md for onboarding new team members into the project -> [guide](https://richardsondx.medium.com/step-by-step-guide-to-writing-better-documentation-to-improve-developer-onboarding-376a4a9181d).
- [x] Prefer a single repository for each project, especially if you are working solo. This keeps things simple and avoids confusion. Only consider splitting into multiple repositories if you have a large team and clear separation between project parts (e.g., backend vs frontend).
- [x] Provide a [Makefile](../Makefile.common.mak) to standardize common commands. Include targets such as install-all for environment setup, lint, test, and build to give new team members a single entry point for routine tasks.
- [x] Remove or archive old, unused, or deprecated projects in github.
- [x] Source code in `/src`, tests in `/tests`, examples or experiments in `/experiments`.
- [x] Document dependencies in `pyproject.toml` or `requirements.txt`.
- [ ] Fill governance form in each project ([here](governance.md)).
- [ ] Protect `main`/`master` branches if more than one person works on the same project ([branch protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule)).
- [ ] Optional: Use [`git-lfs`](https://git-lfs.github.com/) for large files

## Main Branch & Versioning

- [x] The `main/master` branch is the single source of truth. All code should be merged here.
- [x] Avoid opening many branches at once, keep your branch structure simple and focused.
- [x] Use feature branches for specific changes, and delete them after merging.
- [x] Keep your version history clean by using [tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging) for releases instead of long-lived branches.
- [x] Use the branch names like `feat/xxx-xxx`, `fix/xxx-xxx`, `refactore/xxx-xxx`, `docs/xxx-xxx`, etc. to folder the branches.

## Daily Workflow

- [x] `git pull` before work, `git push` after
- [x] Delete merged branches
- [x] Tag releases for tracking ([tagging guide](https://git-scm.com/book/en/v2/Git-Basics-Tagging))
- [x] Never force-push shared branches
- [x] Optional: Use pre-commit hooks for formatting & linting

## Coding Standards & Tooling

- [ ] Follow [PEP8](https://peps.python.org/pep-0008/) for style. For that, use [Black](https://black.readthedocs.io/en/stable/) for formatting, Lint with [pylint](https://pylint.pycqa.org/) or [flake8](https://flake8.pycqa.org/).
- [x] Optional: Use [pre-commit](https://pre-commit.com/) for hooks
- [ ] For notebooks, use [nbstripout](https://github.com/kynan/nbstripout) and spell checkers
- [ ] Interactive scripts: [argparse](https://docs.python.org/3/library/argparse.html) or [click](https://click.palletsprojects.com/)
- [ ] AI???

## Recommended Technologies

- [ ] Version control: GitHub / GitLab
- [ ] Testing: [pytest](https://docs.pytest.org/) / [unittest](https://docs.python.org/3/library/unittest.html)
- [ ] Docs: [Sphinx](https://www.sphinx-doc.org/), [MkDocs](https://www.mkdocs.org/)
- [ ] CI: [GitHub Actions](https://github.com/features/actions)
- [ ] Docs hosting: [ReadTheDocs](https://readthedocs.org/), [GitHub Pages](https://pages.github.com/)

## Useful Links

- [Oh Shit, Git!](http://ohshitgit.com/)
- [Git Best Practices (Seth Robertson)](https://sethrobertson.github.io/GitBestPractices/)
- [Frank Carey's Git Best Practice](https://github.com/frankcarey/git-best-practices)
- [Writing good commit messages](https://github.com/erlang/otp/wiki/Writing-good-commit-messages)
- [Python Guidelines](https://ssciwr.github.io/guidelines/python/)
- [GitHub Best Practice](https://widdowquinn.github.io/github-best-practice/)


## tl;dr

- [x] Use feature branches, keep `main` or `master` clean
- [x] Commit small, focused changes often
- [x] Write clear commit messages ([how-to](https://www.conventionalcommits.org/en/v1.0.0/))
- [x] Always add unit tests for new code (test-driven development -> [guide](https://medium.com/@muirujackson/python-test-driven-development-6235c479baa2))

---
