
<h1 align="center">
    <br>
    Git & Python Best Practices
    <img src="https://www.vectorlogo.zone/logos/python/python-icon.svg" alt="Python" width="40" height="40">
    &nbsp;
    <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="Git" width="40" height="40">
</h1>

## Git commands

```sh
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --list         # check settings

git init                  # start a new repo in current folder
git clone <repo_url>      # copy an existing repo

git add <file>            # stage a file
git add .                 # stage everything
git commit -m "message"   # commit staged changes
git commit -am "message"  # add + commit all tracked changes

git branch                # list branches
git branch <name>         # create new branch
git checkout <name>       # switch to branch
git checkout -b <name>    # create + switch

git fetch                 # get latest info (no changes applied)
git pull                  # fetch + merge remote changes
git push                  # push local commits to remote

git merge <branch>        # merge another branch into current one
git rebase <branch>       # reapply commits on top of another branch

git reset --hard HEAD~n     # discard all local changes (careful!)

git cherry-pick <commit>   # apply a specific commit
```

## Pull Requests

Why do we need it? https://www.hackerone.com/blog/why-you-should-use-pull-requests-developers-essential-tool

How to do that? See https://www.youtube.com/watch?v=nCKdihvneS0.

---

## Repository Organization

- README.md for onboarding new team members into the project -> [guide](https://richardsondx.medium.com/step-by-step-guide-to-writing-better-documentation-to-improve-developer-onboarding-376a4a9181d).
- Prefer a single repository for each project, especially if you are working solo. This keeps things simple and avoids confusion.
- Only consider splitting into multiple repositories if you have a large team and clear separation between project parts (e.g., backend vs frontend).
- Source code in `/src`, tests in `/tests`, examples or experiments in `/experiments`
- Document dependencies in `pyproject.toml` or `requirements.txt`
- Protect `main`/`master` branches if more than one person works on the same project ([branch protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule)).
- Optional: Use [`git-lfs`](https://git-lfs.github.com/) for large files

## Main Branch & Versioning

- The `main/master` branch is the single source of truth. All code should be merged here.
- Avoid opening many branches at once, keep your branch structure simple and focused.
- Use feature branches for specific changes, and delete them after merging.
- Keep your version history clean by using [tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging) for releases instead of long-lived branches.
- Use the branch names like `feat/xxx-xxx`, `fix/xxx-xxx`, `refactore/xxx-xxx`, `docs/xxx-xxx`, etc. to folder the branches.

## Daily Workflow

- `git pull` before work, `git push` after
- Delete merged branches
- Tag releases for tracking ([tagging guide](https://git-scm.com/book/en/v2/Git-Basics-Tagging))
- Never force-push shared branches

## Coding Standards & Tooling

- Follow [PEP8](https://peps.python.org/pep-0008/) for style
- Use [Black](https://black.readthedocs.io/en/stable/) for formatting
- Lint with [pylint](https://pylint.pycqa.org/) or [flake8](https://flake8.pycqa.org/)
- Use [pre-commit](https://pre-commit.com/) for hooks
- For notebooks, use [nbstripout](https://github.com/kynan/nbstripout) and spell checkers
- Interactive scripts: [argparse](https://docs.python.org/3/library/argparse.html) or [click](https://click.palletsprojects.com/)

## Recommended Technologies

- Version control: GitHub / GitLab
- Testing: [pytest](https://docs.pytest.org/) / [unittest](https://docs.python.org/3/library/unittest.html)
- Docs: [Sphinx](https://www.sphinx-doc.org/), [MkDocs](https://www.mkdocs.org/)
- CI: [GitHub Actions](https://github.com/features/actions)
- Docs hosting: [ReadTheDocs](https://readthedocs.org/), [GitHub Pages](https://pages.github.com/)

## Useful Links

- [Oh Shit, Git!](http://ohshitgit.com/)
- [Git Best Practices (Seth Robertson)](https://sethrobertson.github.io/GitBestPractices/)
- [Frank Carey's Git Best Practice](https://github.com/frankcarey/git-best-practices)
- [Writing good commit messages](https://github.com/erlang/otp/wiki/Writing-good-commit-messages)
- [Python Guidelines](https://ssciwr.github.io/guidelines/python/)
- [GitHub Best Practice](https://widdowquinn.github.io/github-best-practice/)


## tl;dr

- Use feature branches, keep `main` or `master` clean
- Commit small, focused changes often
- Write clear commit messages ([how-to](https://chris.beams.io/posts/git-commit/))
- Exclude large files ([.gitignore guide](https://git-scm.com/docs/gitignore))
- Always add unit tests for new code (test-driven development -> [guide](https://medium.com/@muirujackson/python-test-driven-development-6235c479baa2))
- Optional: Use pre-commit hooks for formatting & linting

---
