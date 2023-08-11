<<comment 
This section will cover:

- How to check the exit status of a command 
- How to make decisions based on the status 
- How to use exit statuses in your own scripts 


Every command returns an exit status, ranging from 0 to 255.
0 = success
Other than 0 is thus an error condition 
You can use `man` or `info` to find the meaning of the exit status 


`$?` is a special variable that contains the return code of the previously executed command

for example, if we did:

    ls /file/not/here  # a path where file doesnt exist
    echo "$?" 

we would get an output of `2` to indicate the error 
comment 

# lets run some example code 
chmod 755 '/mnt/c/users/dan/documents/work/wsl/2.1 Exit_status_test_with_ping.sh'   # make it executable 
'/mnt/c/users/dan/documents/work/wsl/2.1 Exit_status_test_with_ping.sh'             # execute it 

<<comment 
output back from above code :

PING google.co.uk (142.250.200.35) 56(84) bytes of data.
64 bytes from lhr48s30-in-f3.1e100.net (142.250.200.35): icmp_seq=1 ttl=116 time=16.1 ms

--- google.co.uk ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 16.113/16.113/16.113/0.000 ms
google.co.uk reachable
comment 

# -----------------------------------------------------------------
<<comment 
In commands/scripts you can actually use `AND` or `OR` in your block, like so:

AND = &&       
OR  = || 

# create a sub folder called 'folder' in the 'tmp' directory, AND then COPY the file `test.txt` to that sub folder from your current working directory 
    mkdir /tmp/folder && cp test.txt /tmp/folder/

# copy the test.txt file to the sub directory 'folder' or to the directory 'tmp' if the first command before the || fails 
    cp test.txt /tmp/folder/ || cp test.txt /tmp
comment

# -----------------------------------------------------------------
<<comment 
If you want to chain separate commands on one line, rather than multi line, you can use the semi-colon

so, for example:

    cp test.txt /tmp/folder1 
    cp test.txt /tmp/folder2

# is the same as doing:
    cp test.txt /tmp/folder1 ; cp test.txt /tmp/folder2 

the important thing to note here, is like multi line commands, exit statuses will not effect the outcome of commands executing.
even if command 1 executes & fails, because of the semicolon, command 2 on that line will still execute
comment 


# -----------------------------------------------------------------
<<comment 
You can control your own exit statuses from a script, by using the `exit` command (values between 0 & 255 can be set by you).
If you don't actually write the exit command, by default, your scripts exit status will be the exit status of whichever command was issued last.
Whenever a `exit` command is executed, it stops the script there and then 

let's look at an example:

    #!/bin/bash
    HOST="google.co.uk"
    ping -c 1 $HOST 
    if [ "$?" -ne "0" ]
    then
        echo "$HOST unreachable
        exit 1
    fi
    exit 0 

so, in the above example, we check if the ping command can indeed contact google.co.uk
if it does, then we skip the main code block and go straight to `exit 0`, indicating our script is a success

if however, the exit status of the ping command is ne 0, then the if block executes, prints a result to terminal, 
sets the script exit status equal to 1, then stops the script.
comment 

# end