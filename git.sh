git clone git@github.com:mkorangestripe/devops.git # clone a git repo

git init # initialize a git repo

git remote -v # show remote URL of the repo
git remote set-url origin git@github.com:mkorangestripe/devops.git # update existing remote origin URL
git remote remove origin # remove remote origin
git remote add origin git@github.com:mkorangestripe/linux.git # add remote origin
git config branch.master.remote origin # for master branch, set remote origin
git config branch.master.merge refs/heads/master

# Add username and email to git config:
git config --global user.name "Your Name"
git config --global user.email "username@example.com"

git branch # lists existing branches
git branch -a # lists existing branches including remote branches
git branch -vv # show the last commit message for each branch
git branch -m feature/PBPRB-1579 # rename the current branch
git branch -d feature/test # delete the branch

git checkout PBPRB-1579 # checkout and switch to the new branch based
git checkout master # switch to master
git checkout -b PBPRB-1651 # create and switch to the new branch based on current branch
git checkout -b feature/PBPRB-1568 develop # create new branch based on develop

git push --set-upstream origin ping-scan-classes # push the current branch and set the remote as upstream

git pull # update local master
git pull origin feature/PBPRB-1579 # update the local branch, this also does a merge

git merge feature/PBPRB-1651 # merge the branch into the current branch

# Rebase the local branch on the current develop branch.
# Incorporate all the commits to develop since the branch was created.
git fetch
git rebase origin/develop
git push --force

git rebase --abort # abort a rebase, if paused

git add msfile2.map # add file to tracking
git add -u # stages modifications and deletions, without new files

git commit msfile2.map -m "Some comment here" # commit changes
git commit --allow-empty -m 'trigger build' # allow empty commit

git push # upload commits to the remote master
git push origin feature/PBPRB-1579 # upload commits to the remote branch
git push -f # force push

git diff --name-only master origin/master # files different between local and remote
git ls-tree HEAD # list files in cwd being tracked under current branch
git ls-tree HEAD -r # list files recursively being tracked under current branch

git status # status of changes
git status origin feature/PBPRB-1651 # status of the branch

git log --pretty=oneline # one line for each change
git log -p msfile1.map # commits for the given file, paged format
git log -p -2 # last two committed changes, paged format

git clean -f # remove untracked files

git checkout nothing.txt # discard changes to nothing.txt
git checkout c4ec54c7863 cleversafe_account_deleter.py # revert file to version in commit
git checkout . # discard changes to all files in the directory

# Revert to a previous commit
git revert 9cc3be0
git push

git rm nothing.txt # remove the file nothing.txt from tracking
git mv file1.txt bin/file2.txt # move/rename file1.txt

# Add more changes to the previous commit, or change the commit message:
git reset --soft HEAD~

# Disregard local changes and reset:
git fetch origin
git reset --hard origin/master
git pull

# A few cvs commands:
mkdir -p devel/project/v4
export CVSROOT=:pserver:<USERNAME>@cvsit.digitalriver.com:/opt/cvs/artifact
cd devel/project
cvs login
cvs co -d v4 art-base/project/v4/

cvs update
cvs add data-sources.xml
cvs commit data-sources.xml
