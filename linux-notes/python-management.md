# Python Versions and Packages

#### Pip

```shell script
pip list             # list packages installed by pip
pip list -v          # show package location and installer
pip list --user      # show only user packages
pip list --outdated  # list outdated and current versions
pip list --uptodate  # list up to date packages
pip list --local     # use when in virtualenv to exclude global packages
pip list --editable  # list editable projects

pip freeze           # list packages in "requirements format"
pip show ipython     # show info about the ipython package
pip search ipython   # search for ipython packages - deprecated

pip install ipython                              # install ipython
pip install --user ipython                       # install ipython in user directory
pip install --upgrade ipython                    # upgrade ipython
pip install --upgrade --force-reinstall ipython  # upgrade or force-reinstall current version
pip install -r requirements.txt                  # install required packages
pip uninstall ipython                            # uninstall ipython
```

#### Install a project in editable mode (develop mode):
```shell script
# Project appears to be installed, but is still editable from the src tree.
# This is done through symlinks.
pip install -e .  # install packages using ./setup.py
pip install -e git+https://git.repo/some_pkg.git#egg=SomeProject
```

#### Venv, Virtualenv
```shell script
pip install virtualenv

# Create a virtual environment using venv:
python -m venv venv

# Create a virtual environment using virtualenv and specify Python 3.9:
# Python 3.9 must be installed prior.
virtualenv venv -p 3.9           

source venv/bin/activate         # activate the virtual environment
pip install -r requirements.txt  # install packages from requirements.txt

# Upgrade all packages in the virtual environment:
pip install --upgrade pip
pip freeze > requirements.txt
sed -i '' 's/==/>=/g' requirements.txt  # use on macOS
sed -i 's/==/>=/g' requirements.txt     # use on Linux
pip install -r requirements.txt --upgrade

deactivate  # deactivate the virtual environment
```

#### Pipenv

```shell script
pip install pipenv

pipenv --python 3.9  # create a virtual environment and specify Python 3.9

# Create a virtual environment, Pipfile, Pipfile.lock, add/install packages from
# requirements.txt if present, and specify Python 3.9:
pipenv --python 3.9 install

pipenv --rm    # remove the virtual environment used by the local directory

pipenv lock    # generate a Pipfile.lock from the Pipfile or requirements.txt
pipenv sync    # installs all packages in Pipfile.lock
pipenv update  # runs lock then sync, with no version constraints in Pipfile this updates all packages

pipenv install psutil     # add psutil to Pipfile and Pipfile.lock and install
pipenv install -d pylint  # add pylint to dev-packages and install

pipenv install       # install packages in Pipfile.lock, create Pipfile.lock from Pipfile if missing
pipenv install -d    # install all dependencies including dev-packages
pipenv install -e .  # install from local setup.py into virtualenv/Pipfile

pipenv graph   # display currently–installed dependency graph
pipenv check   # check installed dependencies for security vulnerabilities

pipenv run python linux_monitoring_datadog.py  # run a command within the virtualenv

pipenv shell   # start a shell within the virtualenv (activate)
# Ctrl+d to deactivate
```

#### Pyenv

```shell script
pyenv install --list     # list available versions of Python
pyenv versions           # list installed versions
pyenv install 3.10.12    # install version 3.10.12
pyenv uninstall 3.10.12  # uninstall version 3.10.12

pyenv global 3.10.12     # set global version to 3.10.12 in ~/.python-version, used when no local version
pyenv local 3.11.4       # set the local version to 3.11.4 in .python-version
pyenv shell 3.11.4       # set the version for the shell using the PYENV_VERSION env var

which python             # show path 
pyenv which python       # show actual path
```

#### Anaconda

```shell script
conda info           # conda version info, etc
conda search python  # list available versions of Python

conda env list                                       # list installed envs
conda list --revisions                               # list changes to the current env

conda create -n env3.10.12 python=3.10.12            # create the env in default location
conda env create -p envs/py3.10.12 -f py3.10.12.yml  # create the env in envs/ and using the yml config
conda create -p envs/mntproj_py3.12.7 python=3.12.7  # create the env in envs/ with the version of Python

conda env update --file mntproj_py3.12.7.yaml        # install packages in yaml file

conda env remove -n env3.10.12                       # remove the env

conda init bash      # configure the shell for anaconda
conda init bash -d   # dry-run, not change to files

conda activate evn.3.10.12  # activate the env

conda list           # list installed packages in an env
conda install pandas # install pandas into the currently-active env
conda remove pandas  # remove pandas from the currently-active env
conda update --all   # update all installed packages in the env

conda deactivate  # deactivate the env
```

#### Packaging

```shell script
# Create dist directory with whl and tar.gz files:
python setup.py sdist bdist_wheel

# Install the wheel package, either of the following:
pip install ping_scan_mkorangestripe-0.0.1-py3-none-any.whl
python -m pip install ping_scan_mkorangestripe-0.0.1-py3-none-any.whl
```
