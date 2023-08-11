<<comment

Logging 


Logs are the who, what, when, where & why.
Output may scroll off the screen.
Script may run unattended (via cron, etc.) 

The `syslog` standard uses facilities and severities to cetgorize messages. 

Facilities: Kern, user, mail, daemon, auth, local0, local7

*local0 & local7 can be used to create custom logs

Severities: emerg, alert, crit, err, warning, notice, info, debug 

Also, log file locations are configurable:

- /var/log/messages
- /var/log/syslog 


# ------------------------------------------------------------

Logging with logger

- the logger utility
- by default creates user.notice.messages 


    logger "Message" 
    logger -p local0.info "Message" 
    logger -t myscript -p local0.info "Message" 
    logger -1 -t myscript "Message" 

comment

# so, we could create a function like so:

    logit () {
        local LOG_LEVEL=$1
        shift
        MSG=$@
        TIMESTAMP=$(date +"%Y-%m-%d %T")

        if [ $LOG_LEVEL = 'ERROR' ] || $VERBOSE
        then
            echo "${TIMESTAMP} ${HOST} ${PROGRAM_NAME} [${PID}]: ${LOG_LEVEL} ${MSG}" 

        fi
    }

<<comment 

so, what is the `logit` function doing?

starts by creating a local variable called LOG_LEVEL, and assigns it the value of the first param
passed to the function 

then, by using shift, it moves all params passed into the left by one. Why? well, this allows us to use the special command $@
which accesses all variables, but it now avoids using the original $1, that we had set to LOG_LEVEL 

so, anything else passed in get read into the MSG variable. A TIMESTAMP variable is created also.
finally, using some conditional logic, we test for an ERROR or $VERBOSE global variable is true (aka verbose option is set)
then echo out a message, which will have:

timestamp, host, prog_name, PID, log_level, & whatever message exists 

Note, instead of echo, we could have used the `logger` command instead within this function 

comment 

# --------------------------------------------------------------------------------------------------

## examples of calling the above function 

#1
# this example sees us use `logit` funtion to set the INFO logging level, with a message of "processing data"
logit INFO "Processing data." 



#2
# in this example, we imagine a function (or could have been a script) called `fetch-data` trying to run, and if it doesnt
# then by using the `||` (OR) option, we instead run our logit function, setting an ERROR logging level with the message 
# that the fetch data failed 
fetch-data $HOST || logit ERROR "Couldnt not fetch data from $HOST" 


# end 