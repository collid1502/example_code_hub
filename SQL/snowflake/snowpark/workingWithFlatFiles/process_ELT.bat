:: Process the ELT workflow 
@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
@echo "~                                                                      ~";
@echo "~  ____                                       _      _____ _   _____   ~";
@echo "~ / ___| _ __   _____      ___ __   __ _ _ __| | __ | ____| | |_   _|  ~";
@echo "~ \___ \| '_ \ / _ \ \ /\ / / '_ \ / _` | '__| |/ / |  _| | |   | |    ~";
@echo "~  ___) | | | | (_) \ V  V /| |_) | (_| | |  |   <  | |___| |___| |    ~";
@echo "~ |____/|_| |_|\___/ \_/\_/ | .__/ \__,_|_|  |_|\_\ |_____|_____|_|    ~";
@echo "~   __ _       _      __ _ _|_|                                        ~";
@echo "~  / _| | __ _| |_   / _(_) | ___   _ __  _ __ ___   ___ ___  ___ ___  ~";
@echo "~ | |_| |/ _` | __| | |_| | |/ _ \ | '_ \| '__/ _ \ / __/ _ \/ __/ __| ~";
@echo "~ |  _| | (_| | |_  |  _| | |  __/ | |_) | | | (_) | (_|  __/\__ \__ \ ~";
@echo "~ |_| |_|\__,_|\__| |_| |_|_|\___| | .__/|_|  \___/ \___\___||___/___/ ~";
@echo "~                                  |_|                                 ~";
@echo "~                                                                      ~";
@echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
@echo.
@echo Starting Snowflake pipeline to run ELT on flat files ... 
@echo.

:: pause for a 3 second break before executing
@timeout /T 3 /NOBREAK > nul 
:: run the load to internal stage python script 
@C:\Path\to\Conda\envs\myEnv\python.exe C:\path\to\script\load_to_interal_stage.py 

:: pause for a 3 second break before executing
@timeout /T 3 /NOBREAK > nul 
:: once files loaded, build stored proc 
@snowsql -c main -f C:\path\to\file\create_stored_proc.sql 

:: pause for a 3 second break before executing
@timeout /T 3 /NOBREAK > nul 
:: once that stored proc is built, call it 
@snowsql -c main -q "CALL MY_SCHEMA.RUN_FLAT_FILES()"

:: ELT process complete 
@echo.
@echo ELT Process complete
@exit 