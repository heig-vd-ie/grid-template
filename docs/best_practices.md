
# 🐍 Git & Python Best Practices 🐙

<p align="center">
    <img src="https://github.blog/wp-content/uploads/2023/02/python-growing.png?w=1032" width="220" alt="Git fun"/>
</p>

## tl;dr

- Use feature branches, keep `main/master` clean
- Commit small, focused changes often
- Write clear commit messages ([how-to](https://chris.beams.io/posts/git-commit/))
- Exclude large files ([.gitignore guide](https://git-scm.com/docs/gitignore))
- Always add unit tests for new code
- Use pre-commit hooks for formatting & linting

---

## Repository Organization

- Source code in `/src`, tests in `/tests`, examples in `/examples`
- Document dependencies in `pyproject.toml` or `requirements.txt`
- Use [`git-lfs`](https://git-lfs.github.com/) for large files
- Protect `main`/`master` branches ([branch protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/using-branch-protection-rules))

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
