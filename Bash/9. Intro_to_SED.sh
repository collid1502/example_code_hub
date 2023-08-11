<<comment
Introduction to Data Manipulation & Text Transformation with Sed

Sed = Stream editor

A stream is data that travels from:
    - one process to another through a pipe
    - one file to another as a redirect 
    - one device to another 


some examples of use:
    - substitue some text for other text 
    - remove lines
    - append text after given lines
    - insert text before certain lines 

comment 

type -a sed   # shows sed is a built in (stored within usr/bin/sed) 

man sed  # manual page for sed 
q # exits man page 

# example
# write 'Dwight is the asst regional manager.' to a file called 9.1 manager.txt
echo 'Dwight is the asst regional manager.' > '9.1 manager.txt' 

# we can use `cat` on the file to pull back the files contents to the output terminal
cat '9.1 manager.txt' 

# now, lets say we wish to replace 'asst' with 'asst to the' in our text line. Sed can do this.
<<comment
we start by using the sed command 
    sed

then, we add our sed script in single quotes. we will tell it to perform a substitution by using the letter `s` like so:
    sed 's

next, we need to specify the pattern to match for replacement. We can choose a complex regex pattern or just a word.
we specify this pattern between two `/` like so:    NB ~ the `/` acts as a delimiter 
    sed 's/asst/

next, we want to type the text we want to replace the matched pattern, like so:
    sed 's/asst/asst to the/

we then close this action off with our final `'` to tody up
    sed 's/asst/asst to the/' 

then, after a space, type the file that we want this action to occur on, like so:

    sed 's/asst/asst to the/' '9.1 manager.txt' 
comment

# execute command 
sed 's/asst/asst to the/' '9.1 manager.txt'  # printed to the terminal output is the updated text string 

# IMPORTANT NOTE ON THE ABOVE EXAMPLE
# sed is NOT altering the contents of the file. It's simply altering the STDOUT of the file.
# were you to actually open the file up, or use a `cat` command like below, the old text would still be there

cat '9.1 manager.txt'   # prints the original output to the terminal 

<<comment
also note, in the above example, that `sed` is case sensitive.
So, the typical `sed` command structure, where we can add additional flags to make case insensitive for example, is:

    sed 's/search-patter/replacement-pattern/addl_flags' 

to make case insensitive then:

    sed 's/asst/asst to the/i' '9.1 manager.txt' 

comment 

# now, we could add another line to our file like so (use two `>>`):
echo 'Jim loves Pam.' >> '9.1 manager.txt' 
cat '9.1 manager.txt' 

# lets add a third line:
echo 'Kevin loves cookies.' >> '9.1 manager.txt' 
cat '9.1 manager.txt' 

# now, back to `sed`
# The sed command will iterate over each line in the file, running the substitute command for any matching pattern it finds in each of the lines
# till it then reaches the end of the file 

<<comment 
Some more info on `sed` replace. 
By default, sed will only replace the FIRST instance of a pattern found on each line.
If you wished to replace a pattern, that may exist multiple times on a line, you would need to 
add the `g` flag to the options in the sed command 
comment 

# now, lets say we want to push our substituted text to a new file, we can do:
sed 's/asst/asst to the/i' '9.1 manager.txt' > '9.2 manager_update.txt' 
cat '9.2 manager_update.txt' # prints output for us to check 


# now, lets look at an example of piping some text into a sed command
# first 
echo '/home/dan' 

# pipe into sed, using the `\` escape character to escape the slashes we wish to pick up in the patterns 
echo '/home/dan' | sed 's/\/home\/dan/\/away\/dan2/'  # this will replace  `/home/dan`` with `/away/dan2` 

# now, that can be a bit messy. The good thing is `sed` lets us use any delimiter, we dont have to use '/'
# so 
echo '/home/dan' | sed 's~/home/dan~/away/dan2~' # should work the same, and looks a bit cleaner 

# multiple sed commands can be issued, seperated by `-e` option :
echo '/home/dan' | sed -e 's~/home/~/away/~' -e 's~dan~chris~'

# end 