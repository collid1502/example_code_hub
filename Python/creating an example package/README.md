# Creating a simple Python package and installing it to Conda Environment

This sub-folder covers an example of creating a simple package, which will be called `Utilities` and then installing it to a Conda Environment

### Steps to build package

1. Use a Python environment with `setuptools` installed (I'll be using conda) and activate it <br>
2. Once inside the active environment on your command line, navigate to the folder structure/directory of your package. You should have a `setup.py` here and other important files like a `README.md` detailing your package or your modules & sub-modules<br>
3. Now, use Python to execute the `setup.py` file, like so:<br>
```
python setup.py bdist_wheel
```
4. This will build a package structure in the directory where the code is, and then create a sub-directory called **dist** which inside will contain the *.whl* file of your package. The naming of the *.whl* file will be based upon the details within `setup.py`

### Steps to install the package

In this example, imagine we wish to install the package to a conda environment.<br>
1. Activate the conda virtual environment you wish to install your package into
2. From the command line, execute:
```
pip install path/to/your/package.whl 
```
*obviously replacing to the correct path where your .whl file is located*<br>
3. You should see a successfully installed message. You can also execute:
```
conda list
```
which will display all your packages in the current environment, and you should now see yours there!