# here, we will use the `ping` command to check our network connectivity to "google.co.uk" 
# the -c (which stands for `count`) 1 option tells the ping command to send just one packet to google for the test 

#!/bin/bash
HOST="google.co.uk"
ping -c 1 $HOST
if [ "$?" -eq "0" ]
then
    echo "$HOST reachable" 
else 
    echo "$HOST un-reachable"
fi

# end