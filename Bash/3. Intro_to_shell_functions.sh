<<comment 

The script takes a look at shell functions 

this will cover:

- why to use functions
- how to create them 
- how to use them 
- variable scope 
- function parameters 
- exit statuses and return codes 

comment 

# ----------------------------------------------------------------------------------------------------

<<comment 

There are two ways to create a function:

1. using the function keyword, followed by the function name you want, then the block of code that makes the function, like so:

    function my-function-name() {
        # code goes here
    }

2. no need to use the keyword, but all else remains the same 

    my-function-name() {
        # code goes here 
    }

comment

# calling a function you create, the below script has a simple hello_world() function it, which prints hello world 
# execute the below script 
chmod 755 '/mnt/c/users/dan/documents/work/wsl/3.1 my_first_function.sh'   # make it executable 
'/mnt/c/users/dan/documents/work/wsl/3.1 my_first_function.sh'             # execute it

# ----------------------------------------------------------------------------------------------------

<<comment
Functions can also call other functions inside of them, or they can accept positional parameters, like scripts do

The first param is stored in $1
The second param in $2 etc.
$@ contains all the parameters 

NOTE - $0 is only ever = to the script itself. It will not be the function name 
comment 

# run the following code for an example of a function being passed a parameter 
chmod 755 '/mnt/c/users/dan/documents/work/wsl/3.2 basic_functions_with_param.sh'   # make it executable 
'/mnt/c/users/dan/documents/work/wsl/3.2 basic_functions_with_param.sh'             # execute it

# ----------------------------------------------------------------------------------------------------

<<comment 
Some notes on `variable` scope.

By default, variables are global in scope, meaning they can be used throughout a script, not just in a function 
However, a variable does need to be defined before it can be used 

if however, you wish to create a `local` variable, that only existed in a function, you could use the "local" keyword, like so:

    local MY_LOCAL_VAR=1

Note, 
Only functions can have local variables 
& it is best practice to keep variables local inside of functions 
comment

# ----------------------------------------------------------------------------------------------------

<<comment 
Exit statuses for functions 

all functions have an exit status. It is either `explicit` or `implicit`

Explicit would be getting the function to define a `return`, for example:

    return <RETURN_CODE>

again, the return keyword only accepts a number, and valid values are between 0 & 255 

Implicit is where the function's exit status is equal to that of the last command that was executed within the function 
comment 

# end 