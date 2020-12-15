# Git Notes

```shell script
git clone git@github.com:mkorangestripe/devops.git  # Clone a git repo
```

```shell script
git init  # Initialize a git repo
```

```shell script
git remote -v  # Show remote URL of the repo
git remote set-url origin git@github.com:mkorangestripe/devops.git  # Update existing remote origin URL
git remote remove origin  # Remove remote origin
git remote add origin git@github.com:mkorangestripe/linux.git  # Add remote origin
git config branch.master.remote origin  # For master branch, set remote origin
git config branch.master.merge refs/heads/master
```

```shell script
# Add username and email to git config
git config --global user.name "Your Name"
git config --global user.email "username@example.com"
```

```shell script
git branch  # Lists existing branches
git branch -a  # Lists existing branches including remote branches
git branch -vv  # Show the last commit message for each branch
git branch -m feature/PBPRB-1579  # Rename the current branch
git branch -d feature/test  # Delete the branch
```

```shell script
git checkout PBPRB-1579  # Checkout and switch to the new branch based
git checkout master  # Switch to master
git checkout -b PBPRB-1651  # Create and switch to the new branch based on current branch
git checkout -b feature/PBPRB-1568 develop  # Create new branch based on develop
```

```shell script
git push --set-upstream origin ping-scan-classes  # Push the current branch and set the remote as upstream
```

```shell script
git pull  # Update local master
git pull origin feature/PBPRB-1579  # Update the local branch, this also does a merge
```

```shell script
git merge feature/PBPRB-1651  # Merge the branch into the current branch
```

```shell script
# Rebase the local branch on the current master branch.
# Incorporate all the commits to master since the branch was created.
git fetch
git rebase origin/master
git pull
git push
```

```shell script
git rebase --abort  # Abort a rebase, if paused
```

```shell script
git add msfile2.map  # Add file to tracking
git add -u  # Stages modifications and deletions, without new files
```

```shell script
git commit msfile2.map -m "Some comment here"  # Commit changes
git commit --allow-empty -m 'trigger build'  # Allow empty commit
```

```shell script
git push  # Upload commits to the remote master
git push origin feature/PBPRB-1579  # Upload commits to the remote branch
git push -f  # Force push
```

```shell script
git ls-tree HEAD  # List files in cwd being tracked under current branch
git ls-tree HEAD -r  # List files recursively being tracked under current branch
```

```shell script
git status  # Status of changes
git status origin feature/PBPRB-1651  # Status of the branch
```

```shell script
git log --pretty=oneline  # One line for each change
git log -p msfile1.map  # Commits for the given file, paged format
git log -p -2  # Last two committed changes, paged format

git show fc8334d9  # Show changes in the commit
git show fc8334d9 --name-only  # Show commit info and files names only
git diff 13a9608  # Diff between given commit and latest commit on current branch
git diff a1699b4 fc8334d9  # Changes the 2nd commit makes to the 1st
```

```shell script
git clean -f  # Remove untracked files
```

```shell script
git checkout nothing.txt  # Discard changes to nothing.txt
git checkout c4ec54c7863 cleversafe_account_deleter.py  # Revert file to version in commit
git checkout .  # Discard changes to all files in the directory
```

```shell script
# Revert to a previous commit
git revert 9cc3be0
git push
```

```shell script
git rm nothing.txt  # Remove the file nothing.txt from tracking
git mv file1.txt bin/file2.txt  # Move/rename file1.txt
```

```shell script
# Add more changes to the previous commit, or change the commit message
git reset --soft HEAD~
```

```shell script
# Disregard local changes and reset
git fetch origin
git reset --hard origin/master
git pull
```

##### A few cvs commands:
```shell script
mkdir -p devel/project/v4
export CVSROOT=:pserver:<USERNAME>@cvsit.digitalriver.com:/opt/cvs/artifact
cd devel/project
cvs login
cvs co -d v4 art-base/project/v4/

cvs update
cvs add data-sources.xml
cvs commit data-sources.xml
```
