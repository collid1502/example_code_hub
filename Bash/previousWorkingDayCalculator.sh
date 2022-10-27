#!/bin/bash 

# Script for testing the calculation of previous weekday from today 
get_previous_busday() {
        if [ "$1" = "" ]
        then
                printf 'Usage: get_previous_busday (base_date)\n' >&2
                return 1
        fi
        base_date="$1"
        if ! day_of_week="$(date -d "$base_date" +%u)"
        then
                printf 'Apparently "%s" was not a valid date.\n' "$base_date" >&2
                return 2
        fi
        case "$day_of_week" in
          (0|7)         # Sunday should be 7, but apparently some people
                        # expect it to be 0.
                offset=-2       # Subtract 2 from Sunday to get Friday.
                ;;
          (1)   offset=-3       # Subtract 3 from Monday to get Friday.
                ;;
          (*)   offset=-1       # For all other days, just go back one day.
        esac
        if ! prev_date="$(date -d "$base_date $offset day")"
        then
                printf 'Error calculating $(date -d "%s").\n' "$base_date $offset day"
                return 3
        fi
        printf '%s\n' "$prev_date"
} 

# --------------------------------------------------------------------
# some examples in use 

echo $(date)   # returns today's date 

# use today's date inside the function 
get_previous_busday $(date) 

# call function, passing in today's date as parameter, and assign to variable 
LWD=$(get_previous_busday $(date)) 
echo $LWD