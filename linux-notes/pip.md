# Python Pip, Pipenv, Virtualenv

### Pip

```shell script
pip list  # list packages installed by pip
pip list -v  # show package location and installer
pip list --user  # show only user packages
pip list --outdated  # list outdated and current versions
pip list --uptodate  # list up to date packages
pip list --local  # use when in virtualenv to exclude global packages
pip list --editable  # list editable projects

pip freeze  # list packages in "requirements format"
pip show ipython  # show info about the ipython package
pip search ipython  # search for ipython packages - deprecated

# Get packages inside Docker container:
sudo docker run --rm -it python:3
pip3 freeze | grep -i yaml #  run in container
python -V  # run in container

pip install ipython  # install ipython
pip install --user ipython  # install ipython in user directory
pip install --upgrade ipython  # upgrade ipython
pip install --upgrade --force-reinstall ipython  # upgrade or force-reinstall current version
pip install -r requirements.txt  # install required packages
pip uninstall ipython  # uninstall ipython
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
virtualenv virt-cos-sdk  # creates a virtual environment in the directory
. virt-cos-sdk/bin/activate  # activate the virtual environment
# Do the package installs with the virtualenv active
deactivate  # deactivate the virtual environment
# Note, a leftover .Python file from virtualenv can cause problems when recreating the env.
```

### Pipenv

```shell script
pipenv --python 3.8  # create a project using Python 3.8
pipenv --python 3.8 install  # create project and Pipfile and Pipfile.lock

pipenv lock  # generate a Pipfile.lock from the Pipfile or requirements.txt
pipenv install psutil  # Add psutil to Pipfile and Pipfile.lock and install
pipenv install  # install packages in Pipfile.lock, create Pipfile.lock from Pipfile if missing
pipenv sync  # installs all packages in Pipfile.lock
pipenv update  # runs lock then sync, with no version constraints in Pipfile, this updates all packages

pipenv graph  # display currently–installed dependency graph
pipenv check  # check installed dependencies for security vulnerabilities

pipenv run python linux_monitoring_datadog.py  # run a command within the virtualenv
pipenv shell  # start a shell within the virtualenv
```

### Packaging (Python 2)

```shell script
setup.py  # defines packages to install, can reference requirements.txt for requirements
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
