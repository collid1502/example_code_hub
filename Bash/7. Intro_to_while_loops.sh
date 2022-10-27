<<comment 

This section covers the topic "While Loops"


covering:

- while loops
- infinite loops
- loop control 
    -- explicit number of times 
    -- user input 
    -- command exit status 

- reading files line by line
- 'break` and `continue` 

comment 


# while loop format 
# where typically, a command inside the loop is effecting/changing the condition being checked for
# an example being, WHILE COUNTER < 10    and inside the the loop, you keep adding 1 to COUNTER (assuming it had a preset value)  
while [ CONDITION_IS_TRUE ]
do
    command1
    command2
    commandN
done

# example loop 1
INDEX=1
while [ $INDEX -lt 4 ]
do
    echo "Creating project-${INDEX}" 
    ((INDEX++))  # use double brackets to do mathematical operations, and the ++ notation adds 1 by default to the value INDEX
done

#example loop 2
INDEX=1
while [ $INDEX -lt 4 ]
do
    echo "Creating project-${INDEX}" 
    ((INDEX=INDEX+1))  
done

# ------------------------------------------------------------------------

# infinite loop format 
while true
do
    commandN
    sleep 1
done 

# the `true` command always has an exit status of "0". Thus, the loop will run infintely (until you close the command line session) 


# ------------------------------------------------------------------------
# Reading a file line by line 

LINE_NUM=1
while read LINE
do
    echo "${LINE_NUM}: ${LINE}"
    ((LINE_NUM=LINE_NUM+1))
done < /file/you/wish/to/read   # done followed by `<` symbol, then by the file path, will allow this to work

# ------------------------------------------------------------------------

# to exit a loop before its natural end, but NOT exit the script as a whole, you could use the 
# break statement 
    break
    ;;

# in the command section of the loop, where based on some condition being met, you wish to break the loop

# you can use the continue statement, to skip processing next commands in the one iteration of a loop, 
# and go back and start processing the next iteration of the loop from the start of the loop command
    continue


# end 