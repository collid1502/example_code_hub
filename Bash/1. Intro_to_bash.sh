# change to home directory 
cd ~

# command to change to directory of choice 
cd /mnt/c/users/dan/documents/work/wsl/ 

# command to list all sub files / folders in a directory 
ls 

# -----------------------------------------------------------------------------------------------------------------------
# Note to self, have set VS Code up to execute highlighted text in terminal with F3 command using `code runner` extension 

<<comment 
SECTION : Introduction 

Scripts contain a series of commands.
An interpreter executes commands in the script.
Anything you can type in the command line, you can put in a script
Really handy for automating tasks 

a simple script example 
inside a .sh script we have the following: 

    #!/bin/bash
    echo "Scripting is fun" 

The above two lines in a script, when ran, will write back to the terminal an output of "scripting is fun" 
I have created the above 2 lines, in an example script called 1.1 basic_script.sh

when the first line of a script is "#!/bin/bash" or "#!/bin/sh" this is known as `she-bang` (because #=sharp, !=bang >>> Sharp-Bang  >>> ShaBang)
this is basically telling the script what interpreter to use, before then passing the script as a variable, into that interpreter 

In order to make the above script executable, in our terminal we would need to run:
NB ~ where paths/scripts have spaces, enclose in quotes
comment

chmod 755 '/mnt/c/users/dan/documents/work/wsl/1.1 basic_script.sh'  # to provide execution rights on the script
'/mnt/c/users/dan/documents/work/wsl/1.1 basic_script.sh'            # to execute 

# can see that Scripting is fun was printed to the output terminal 

# --------------------------------------------------------------------------------------------------------

<<comment
SECTION: Variables 

basically storage locations that have a name
can be thought of as `Name-Value` pairs  ... aka AGE="28" 
the syntax is the basic :

    VARIABLE_NAME="Value" 

Variables are case sensitive 
Note, it is a custom for variable names to be in all uppercase 

an example of using a variable 
execute the script `1.2 basic_variable_script.sh` 
comment 

chmod 755 '/mnt/c/users/dan/documents/work/wsl/1.2 basic_variable_script.sh'
'/mnt/c/users/dan/documents/work/wsl/1.2 basic_variable_script.sh' 


<<comment
you can also assign a command output to a variable
for example, the command `hostname` result, could be stored in SERVER_NAME like so:

    #!/bin/bash
    SERVER_NAME=$(hostname) 
    echo "Your are running this script on ${SERVER_NAME}." 
comment

chmod 755 '/mnt/c/users/dan/documents/work/wsl/1.3 basic_command_output_variable.sh'
'/mnt/c/users/dan/documents/work/wsl/1.3 basic_command_output_variable.sh' 

# variable names can contain letters, digits or underscores.
# they can start with a letter or underscore, but NOT a digit 


# --------------------------------------------------------------------------------------------------------
<<comment
SECTION: tests

tests are where we may want to execute different commands or scripts, based on the outcome of a test we perform
for example, if today's date = birthday, then send card, otherwise don't send card  etc. etc. 

the syntax for tests / conditions is:

    [ condition-to-test-for ] 

Some File Operator example tests 

    -d FILEPATH          # Returns True if FILEPATH is a directory 
    -e FILEPATH          # Returns True if FILEPATH exists 
    -f FILEPATH          # Returns True if FILEPATH exists and is a regular file 
    -r FILEPATH          # Returns True if FILEPATH is readable by you 
    -s FILEPATH          # Returns True if FILEPATH exists and is not empty 
    -w FILEPATH          # Returns True if FILEPATH is writable by you 
    -x FILEPATH          # Returns True if FILEPATH is executable by you 
    -z STRING            # Returns True if STRING is empty 
    -n STRING            # Returns True if string is NOT empty 
    STRING1 = STRING2    # Returns True if STRING1 and STRING2 are equal 
    STRING1 != STRING2   # Returns True if STRING1 and STRING2 are NOT equal 

you can also do numerical tests like:

    arg1 -eq arg2
    arg1 -ne arg2

and use -lt, -le, -gt, -ge   (less than, greater than etc etc) 
comment

# --------------------------------------------------------------------------------------------------------
<<comment
SECTION: Making Decisions ... The `IF` statement 

by using an "if then" statement, we can achieve different results based on our tests, like so:

    if [ condition-is-true ]
    then
        command 1
        command 2
        command N
    fi
comment

# run the test script 1.4 basic_test_if_then.sh 
chmod 755 '/mnt/c/users/dan/documents/work/wsl/1.4 basic_test_if_then.sh'   # make it executable 
'/mnt/c/users/dan/documents/work/wsl/1.4 basic_test_if_then.sh'             # execute it 


<<comment
another example is to use an "if / else" statement like so:

    if [ condition-is-true ]
    then
        command 1
    else
        command N
    fi


for multiple condition tests, use the keyword "elif" like so :

    if [ condition-is-true ]
    then
        command 1
    elif [ condition-2-is-true ]
    then
        command 2
    else
        command N
    fi
comment 


# --------------------------------------------------------------------------------------------------------
<<comment
SECTION: actions on a list of items ... the `For Loop` 


an example of iterating over items in a list:

    for VARIABLE_NAME in ITEM_1 ITEM_2 ITEM_N
    do
        command 1
        command 2
        command N
    done

comment

# make executable & run the script 1.5 basic_for_loop.sh
chmod 755 '/mnt/c/users/dan/documents/work/wsl/1.5 basic_for_loop.sh'   # make it executable 
'/mnt/c/users/dan/documents/work/wsl/1.5 basic_for_loop.sh'             # execute it 

<<comment
it is also common practice for the list of variables to be stored in their own variable, like so:

    #!/bin/bash
    COLOURS="red green blue"

    for COLOUR in $COLOURS
    do
        echo "COLOUR: $COLOUR"
    done

comment 

# --------------------------------------------------------------------------------------------------------
<<comment
SECTION: Positional Parameters 

For example, if in the command line we type:

    script.sh param1 param2 param3 

this is passing 3 parameters into our script for use
these can be accessed within the script by `positional parameters`

for this example:

    $0  =  "script.sh"    # aka the script name 
    $1  =  "param1"
    $2  =  "param2"
    $3  =  "param3"       # and so on ... 


also, instead of referring to $1, $2 etc. in scripts, we can just assign more useful variable names to them, like so:

    #!/bin/bash 
    USER=$1  # the first parameter is the user name 
    
    echo "Executing script: $0" 
    echo "Running as user: $USER" 
    # do some stuff 


you can also access all the parameters from position 1 until the nth by using the `$@` - like this example:

    #!/bin/bash
    echo "Executing script: $0" 
    for USER in $@
    do
        echo "Running as user: $USER"
        # do some stuff 
    done

that way, we can pass multiple params at our sh script, in this example user names, and it will execute each of them in a loop 

comment 


# --------------------------------------------------------------------------------------------------------
<<comment
SECTION: Accepting User Input (STDIN)

The read command accepts STDIN, which typically comes from a user typing, but can also come from the output of a command or so on

syntax:
    read -p "PROMPT" VARIABLE 


here's an example:

    #!/bin/bash
    read -p "Enter your user name: " USER 
    echo "Executing script as user: $USER" 
    # do some stuff 

comment 

# end 