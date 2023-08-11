<<comment
This script focuses on taking a look at wildcards in shell scripting 

this covers:

- what wildcards are
- when and where they can be used 
- the different types of wildcards 
- how to use wildcards with various commands 


wildcards are a character or string used for pattern matching 

the two main wildcards are:

*  ~  matches zero or more characters (aka anything)

    *.txt 
    a*
    a*.txt 


? ~ matches exactly one character 

    ?.txt
    a?
    a?.txt 



# -------------------------------------

There is also what's known as a character class

[] = specifying a character class

Matches any of the characters included between the brackets. Matches exactly one character.

for example, if you were looking to if something matched having any vowel in its name, you could 
use a character class:

    [aeiou] 

if any of those letters match in the name of the thing you are testing, it actions

you could also do something like:

    ca[nt]* 

Now, this would find any words starting with `ca`
which then has either a `n` or `t` next
which then has `ANY` pattern, or nothing, come after it

example words that it would catch:

- can
- cat
- candy
- catch 


Now, to do the reverse, we can use `!`
Remember, it only matches exactly one character.

and exclude any file that starts with a vowel, we can use the `!` option
like so:

    [!aeiou]*

- baseball   # would be found
- football   # would be found 
- arts       # would NOT be found


# -------------------------------------

using a `Range` wildcard
Say we wanted to match any file that starts with the letters:  a,b,c,d or e
then we could do:

    [a-e]* 


or say we wished to match any file that started with a 3,4,5 or 6

    [3-6]* 


There are also a host of pre-defined ranges you can use, inclduing:

- [[:alpha:]]   # matches any lower or upper case char
- [[:alnum:]]   # matches any lower or upper case char and decimal digits 
- [[:digit:]]   # matches any digit from 0-9
- [[:lower:]]   # matches any lowercase letter
- [[:space:]]   # matches any whitespace, like spaces, tabs, newline chars
- [[:upper:]]   # matches any uppercase letter 

so, what if you wanted to match an `*` character?
well, you would need to "escape" it first, using a an escape character, which is "\" 

for example, match all files that end with a question mark "?" 

    *\?    # using the "\" to escape the "?" wildcard value, and take its literal raw value for a searh pattern 

comment

# end 