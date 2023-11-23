:: This is an example script of a .bat file that can be run via windows CMD to execute steps
:: and run a process

:: in this simple example, let's look at doing something as simple as running
:: a Snowflake script through the SnowSQL CLI, then a Python script via conda env
:: what happens INSIDE those scripts doesn't really matter here, this is simply to show
:: the means by which you could execute multiple processes etc.

:: NOTE - using `@` in front on a command restricts the command being printed to terminal during run
@echo Starting example batch process ...

:: change to correct directory if not already there
@cd C:\my_project\folder\scripts

@echo Running SnowSQL script ...
:: this connects to SnowSQL CLI via the "main" connection details saved in environment config file
@snowsql -c main -f snowflake\load_data.sql -o quiet=true -o friendly=false -o timing=false
@if not ErrorLevel 1 (
    @echo Snowflake data has loaded
) else (
    :: exit process due to error
    @echo ERROR - Snowflake load has failed
    @exit
)
@echo.

:: also use a quick time break if wanted, to pause the script for 5 seconds
@REM commented out for the moment
:: @timeout /T 5 /NOBREAK >nul 

:: now execute Python script via conda
@echo Running Python Snowpark script ...
@C:\path\to\conda\envs\my_environment\python.exe python\etl.py 
@if not ErrorLevel 1 (
    @echo Python snowpark ETL has finished
) else (
    :: exit process due to error
    @echo ERROR - Python snowpark ETL has failed
    @exit
)
@echo.

@echo End of batch process!
@exit
:: end of file