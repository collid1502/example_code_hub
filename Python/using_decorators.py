# Simple example of using a decorator, to wrap a function with another function
# This example will look at a decorator than logs function runs

from typing import Callable, Any, TypeVar

# define a type variable for functions 
func = TypeVar('func', bound=Callable[..., Any]) 


# define logging function
def logger(use_function: func) -> func:
    """
    A simple decorator that takes a function, and adds some logging/print statements around that function execution
    """
    def log_wrapper(*args: Any, **kwargs: Any) -> Any:
        print(f"Executing function: {use_function.__name__}") 
        result = use_function(*args, **kwargs) 
        print(f"Function {use_function.__name__} Completed") 
        return result 
    return log_wrapper 


# basic example with use 
@logger
def simple_adder(a: int, b: int) -> int:
    if (isinstance(a, int) == False) or (isinstance(b, int) == False):
        raise ValueError("Integers not provided. Please provide integers")
    return a + b # returns the sum of the two passed numbers 


# ----------------------------------------------------------------------------------------------------
if __name__ == '__main__':
    print("Running test with values: a=4 & b=5 ... \nresult should be 9")
    print() 
    test_result = simple_adder(4, 5) 
    print(f"Test result outcome: {test_result}")
    