# Python Versions and Packages

### Pip

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

### Install a project in editable mode (develop mode):
```shell script
# Project appears to be installed, but is still editable from the src tree.
# This is done through symlinks.
pip install -e .  # install packages using ./setup.py
pip install -e git+https://git.repo/some_pkg.git#egg=SomeProject
```

### Virtualenv

```shell script
mkdir virt-cos-sdk
virtualenv virt-cos-sdk      # creates a virtual environment in the directory
. virt-cos-sdk/bin/activate  # activate the virtual environment
# Do the package installs with the virtualenv active
deactivate                   # deactivate the virtual environment
# Note, a leftover .Python file from virtualenv can cause problems when recreating the env.
```

### Pipenv

```shell script
pipenv --python 3.8          # create a project using Python 3.8
pipenv --python 3.8 install  # create project and Pipfile and Pipfile.lock
pipenv --rm                  # remove virtualenv used by local directory

pipenv lock    # generate a Pipfile.lock from the Pipfile or requirements.txt
pipenv sync    # installs all packages in Pipfile.lock
pipenv update  # runs lock then sync, with no version constraints in Pipfile this updates all packages

pipenv install psutil  # add psutil to Pipfile and Pipfile.lock and install
pipenv install         # install packages in Pipfile.lock, create Pipfile.lock from Pipfile if missing
pipenv install -e .    # install from local setup.py into virtualenv/Pipfile

pipenv graph   # display currently–installed dependency graph
pipenv check   # check installed dependencies for security vulnerabilities

pipenv run python linux_monitoring_datadog.py  # run a command within the virtualenv
pipenv shell                                   # start a shell within the virtualenv
```

### Pyenv

```shell script
pyenv install --list     # list available versions of Python
pyenv versions           # list installed versions
pyenv install 3.10.12    # install version 3.10.12
pyenv uninstall 3.10.12  # uninstall version 3.10.12

pyenv global 3.10.12     # set 3.10.12 as default version
pyenv local 3.11.4       # set the version to 3.11.4
pyenv shell 3.11.4       # set the version for the shell using the PYENV_VERSION env var

which python             # show path 
pyenv which python       # show actual path
```

### Anaconda

```shell script
conda search python  # list available versions of Python

conda env list                                       # list installed envs
conda create -n env3.10.12 python=3.10.12            # create the env in default location
conda env create -p envs/py3.10.12 -f py3.10.12.yml  # create the env in envs/ and using the yml config
conda env remove -n env3.10.12                       # remove the env

conda init bash      # configure the shell for anaconda
conda init bash -d   # dry-run, not change to files

conda activate evn.3.10.12  # activate the env
conda deactivate            # deactivate the env

conda list           # list installed packages in an env
conda install pandas # install pandas into the currently-active env
conda remove pandas  # remove pandas from the currently-active env
conda update --all   # update all installed packages in the env
```

### Packaging (Python 2)

```shell script
setup.py               # defines packages to install, can reference requirements.txt for requirements
ping_scan/__init__.py  # required for directories to be seen as packages
ping_scan/ping_scan.py
LICENSE
README.md
tests/  # for unit tests, if any
```

### Packaging (Python 3)

```shell script
# This creates a dist directory with a .whl and a tar.gz file:
python3 setup.py sdist bdist_wheel

# Install a wheel package, either of the following:
pip3 install ping_scan_mkorangestripe-0.0.1-py3-none-any.whl
python3 -m pip install ping_scan_mkorangestripe-0.0.1-py3-none-any.whl
```
