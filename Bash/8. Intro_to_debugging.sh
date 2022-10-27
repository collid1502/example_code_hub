<<comment
So, why debug?

- a bug just means an error
- examine the inner workings of your script 
- determine the root of unexpected bhaviour 
- fix bugs/errors

comment

# -----------------------------------------------------------------------
# built in debugging 

#  the -x option prints commands as they execute 
#  after substitutions and expansions 
#  called an x-trace, tracing or print debugging 

    #!/bin/bash -x   # will do the whole script


# if you only wish to print debug a portion of a larger script then:
# so, set `-x` to print debug
# set `+x` to stop the print debugging 


# another useful option is the `-e` option
# it causes your script to exit on an error, when added to the shebang line at the start of the file 

# -----------------------------------------------------------------------

<<comment 
other ideas around de-bugging:

- variables in debugging
- manual debugging tips
- syntax highlighting 
- more bash built-ins
- file types 


Note, file types between systems, say windows to linux, can have issues around "carriage return".
aka, marking the end of a line, and tabbing down to a new one. when you view a file, these wont
always be visible, but can mess up the execution of commands etc.

a common carriage return when executing a windows file on linux, is ^M

The `cat -v` command should help show any carriage returns in a file
comment


# end 