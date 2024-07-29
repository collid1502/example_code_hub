# Explore unit testing in PySpark with `pytest`

This sub-dir looks at how we can use PyTest to initiate tests against PySpark functions and ensure that they work as expected!


### pytest

Pytest uses file and function names (prefaced with test_) to identify test functions (see this link for more details).<br>
In our example, our test scripts are named test_*.py, and the class names start with Test, and test function names begin with test_*.


### fixtures

Fixtures in pytest are reusable components you define to set up a specific environment before a test runs and tear it down after it completes. They provide a fixed baseline upon which tests can reliably and repeatedly execute. Fixtures are flexible and can be used for many purposes, such as:

- Creating a SparkSession (with test-specific configs) to be shared across tests
- Setting up database tables that are to be used for testing
- Downloading jars necessary for a Spark application to process correctly, for example, using PyDeequ!
- Providing system configurations or test data
- Cleaning up after tests are run
- Fixtures can be scoped at different levels (function, class, module, session), meaning you can set a fixture to be invoked once per test function, once per test class, once per module, or once per session, respectively

### conftest.py

In pytest, `conftest.py` is a configuration file used to define fixtures, hooks, and plugins that can be shared across multiple test files.

In our example conftest.py we create a SparkSession variable (called spark) as a fixture and this SparkSession will be injected into the functions that it is required.



With the testing suite set up, we can run the code

```
pytest
```

from our environment, in the root project folder, and it will initiate our tests for us!

This can then let us know of all passes & fails!