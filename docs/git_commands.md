# Git Commands

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

git reset --soft HEAD~n   # return back the changes into stage mode
git reset --hard HEAD~n   # discard all local changes (careful!)

git cherry-pick <commit>  # apply a specific commit
```
