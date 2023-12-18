# Snowpark : Working with flat files 

Imagine we have a process where by we use the SnowCLI to load some files to an Internal Snowflake Stage, and then have snowpark python code written into a stored procedure<br>
that can process the individual flat files. This example could be used in the case of having unqualified-text CSV files, meaning commas within data can misalign the headers<br>
and cause `COPY INTO` commands to fail. Instead, we may need to work around with doing file stream processing, so that action can be taken per line.

In this sub-folder, there will be example code to show loading CSV files to an internal stage, the python snowpark code through the `main()` handler, and then wrapping that python snowpark code into a stored procedure that can be called after the files have been loaded