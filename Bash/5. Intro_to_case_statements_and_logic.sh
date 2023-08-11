<<comment
Case statements

these can be used as an alternative to many if/elif statements, and often, 
can make code easier to read when complex

the pattern for writing a case statement is as follows:

    case "$VAR" in 
        pattern_1)
            # commands / code goes here 
            ;; # terminates case statement after pattern_1 matches and code in block executes 
        pattern_N)
            # commands / code goes here
            ;; # terminates case statement after pattern_N matches, given pattern_1 hasn't, and code in block executes 
    esac 

# Note - `esac` ends a case statement block. It's `case` spelled backwards 

# Another Note - using `in` then specifying a value IS case sensitive, for example:

    case "$1" in 
        dan)
            echo "Users name is dan" ; echo "he is 28"
            ;;
        chris)
            echo "Users name is chris" ; echo "he is 25"
            ;;
    esac 

now, in the above, if $1 is 'dan' or 'chris' the echo will happen.
otherwise, nothing happens, and the case statement just terminates and the script moves on.
the KEY thing here is ... if $1 is 'Dan'  .... then the pattern doesn;t match
because of case sensitivty, so keep an eye out! 


Now, for an example, where we can use character classes to help out:

    read -p "Enter y or n: " ANSWER 
    case "$ANSWER" in 
        [yY]|[yY][eE][sS])
            echo "You have entered yes"
            ;;
        [nN]|[nN][oO])
            echo "You have entered no" 
            ;;
        *)
            echo "Invalid answer"
            ;;
    esac 

The above example uses pattern matching to allow a user t type:
Note ~ the `|` allows multiple pattern matching types aka `OR`

    - Y / y / Yes / yes 
    - N / n / No / no 

and the case statement still work.
It uses the final wildcard `*` of anything, to have a catch all of anything else entered, and print a message of invalid answer.
comment 

# end