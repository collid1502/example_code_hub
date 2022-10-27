#!/bin/bash
function hello_you() {
    echo "Hello there $1" 
}

# call it & provide a name as a parameter 
hello_you Dan 


# now, if we wanted to do multiple names (parameters) passed to a function?
# we would do
function hello_you_multiple() {
    for NAME in $@
    do
        echo "Hello there $NAME"
    done
}

# now call it, providing 3 different names
hello_you_multiple Chris Jamie Michael 

# end 