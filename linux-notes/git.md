# Git

#### clone, init

```shell script
git clone git@github.com:mkorangestripe/linux.git  # clone the git repo

git init  # initialize a git repo
```

#### Repo config

```shell script
git remote -v  # show remote URL of the repo
git remote set-url origin git@github.com:mkorangestripe/devops.git  # update existing remote origin URL
git remote remove origin
git remote add origin git@github.com:mkorangestripe/linux.git

git config branch.master.remote origin  # set remote origin for master branch
git config branch.master.merge refs/heads/master
```

#### Global config

```shell script
# Add username and email to git config:
git config --global user.name "Your Name"
git config --global user.email "username@example.com"

git config --global http.sslBackend schannel  # use Windows certificate store
git config --global core.autocrlf false       # do not convert newline characters
```

#### add

```shell script
git add msfile2.map  # add file to tracking, add changes to file
git add -u           # add changes for all tracked files
```

#### commit

```shell script
git commit msfile2.map -m "Some comment here"  # commit changes
git commit --allow-empty -m 'trigger build'    # allow empty commit
git commit --amend                             # amend the last commit message
```

#### push

```shell script
git push                            # upload commits to the remote master
git push origin feature/PBPRB-1579  # upload commits to the remote branch
git push -f                         # force push
```

#### stash

```shell script
git stash      # stash changes
git stash pop  # remove a single stashed state from the stash list and reapply it
```

#### ls-tree

```shell script
git ls-tree HEAD     # list files in CWD being tracked under current branch
git ls-tree HEAD -r  # list files recursively being tracked under current branch
```

#### status

```shell script
git status                            # status of changes
git status origin feature/PBPRB-1651  # status of the branch
```

#### clean

```shell script
git clean -f  # remove untracked files
```

#### rm, mv

```shell script
git rm nothing.txt              # remove the file nothing.txt from tracking
git mv file1.txt bin/file2.txt  # move/rename file1.txt
```

#### log

```shell script
git log --pretty=oneline  # one line for each change
git log -p msfile1.map    # commits for the given file, paged format
git log -p -2             # last two committed changes, paged format
```

#### show

```shell script
git show fc8334d9              # show changes in the commit
git show fc8334d9 --name-only  # show commit info and files names only
```

#### diff

```shell script
git diff 13a9608           # diff between given commit and latest commit on current branch
git diff a1699b4 fc8334d9  # diff between the two commits
```

#### checkout

```shell script
git checkout nothing.txt              # checkout the last commited local version nothing.txt
git checkout c4ec54c7863 nothing.txt  # checkout the file from the commit
git checkout .                        # checkout the last committed version of all files

git checkout c4ec54c7863              # checkout the commit
git checkout main                     # checkout the latest commit of the main branch
```

#### revert

```shell script
git revert 9cc3be0  # revert the commit
```

#### reset

```shell script
# Reset to the state to before last commit:
# Useful when adding more changes to the previous commit, or changing the commit message.
git reset --soft HEAD~

# Reset to the commit, changes are still added:
git reset --soft 921b5ea6

# Reset to the commit, changes will need to be added, --mixed is default mode
git reset --mixed 921b5ea6

# Reset to the commit, discard any local changes to tracked files:
git reset --hard 921b5ea6

# Reset to the commit at origin/main, discard any local changes to tracked files:
git fetch origin
git reset --hard origin/main  # origin/master with older repos
```

#### Branches

```shell script
git branch                        # lists existing branches
git branch -a                     # lists existing branches including remote branches
git branch -vv                    # show the last commit message for each branch
git branch -m feature/PBPRB-1579  # rename the current branch
git branch -d feature/test        # delete the branch

git checkout PBPRB-1579                     # checkout and switch to the new branch based
git checkout master                         # switch to master
git checkout -b PBPRB-1651                  # create and switch to the new branch based on current branch
git checkout -b feature/PBPRB-1568 develop  # create new branch based on develop

git push --set-upstream origin ping-scan-classes  # push the current branch and set the remote as upstream

git pull                            # git fetch followed by git merge FETCH_HEAD
git pull origin feature/PBPRB-1579  # merge updates from the remote branch into the local branch

git merge feature/PBPRB-1651  # merge the branch into the current branch
```

#### rebase

```shell script
# Rebasing incorporate all the commits to main since the branch was created.

git fetch  # download branches, commits, tags

git rebase origin/main  # rebase the local branch on the current main branch
git rebase main         # rebase the current branch on main

git rebase --continue   # run after conflict has been resolved
git rebase --abort      # abort a rebase if paused

git pull
git push
```

#### Tags

```shell script
git tag          # list tags
git show v1.0.0  # show tag info

# Create an annotated tag:
git tag -a v1.2.0 -m "Round robin method with weighted ratio."

# Tag a previous commit:
git tag -a v1.1.0 49cfd4e -m "Loadbalancer app run with Gunicorn."

git push --tags                # push tags
git tag -d v1.0                # delete a local tag
git push --delete origin v1.0  # delete a remote tag
```
