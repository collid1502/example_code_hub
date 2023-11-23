# SnowSQL CLI

The snowSQL CLI tool can be accessed via command line |(once installed) like so:<br>
```
snowsql --version # show the version installed
```
### connect & run an sql script

this connects to SnowSQL CLI via the "main" connection details saved in environment config file<br>
```
snowsql -c main -f stage_local_file.sql -o quiet=true -o friendly=false -o timing=false
```

And thats an example of using the SnowSQL CLI