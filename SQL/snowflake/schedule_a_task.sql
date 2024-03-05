/*
The following example will show a simple process that is designed to source Bank Holiday data, 
for the United Kingdom & Ireland, as well as some regions of the USA.
This will simply create a dataset, to be stored in a Utility area for analysts to use in reporting
or analysis, which will show dates of Bank Holidays (& the holiday observed)

The process will utilise Python packages, run via Snowpark, to save to a snowflake table, continuously
overwriting data with each refresh (as the data source period is a multiyear window).
That process will be placed into a stored procedure, and the stored procedure will be called as part of 
a task. That task will be set on a schedule, to be ran by snowflake remotely, independent of user action
*/
-- -----------------------------------------------------------------------------------------------------

-- SET WAREHOUSE 
USE WAREHOUSE "TEST_SF_WAREHOUSE";
-- SET DATABASE 
USE DATABASE "TEST_SF_DATABASE";
-- SET SCHEMA 
USE SCHEMA "UTILITY_DATA_ASSETS";


-- BUILD THE STORED PROCEDURE VIA A SNOWPARK SCRIPT 
CREATE OR REPLACE PROCEDURE UTILITY_DATA_ASSETS.RUN_BANKHOLS_SOURCE()
RETURNS STRING 
LANGUAGE PYTHON 
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python', 'pandas', 'holidays') -- Any packages beyond standard python libs
HANDLER = 'app'
EXECUTE AS CALLER -- Required if any of the process needs to create/use a Temp Table 
AS
$$
# Imports
from datetime import dateimte as dt 
import pandas as pd
import holidays
import snowflake.snowpark as snowpark 
from snowflake.snowpark.functions import * 
from snowflake.snowpark.types import * 


# Application 
def app(snowpark: snowpark.Session):
    # specify countries &/or states to look up & collect 
    countries_states = [
        {"country": "UnitedKingdom", "state": "England"}, # England bank hols
        {"country": "UnitedKingdom", "state": "Wales"}, # Wales bank hols
        {"country": "UnitedKingdom", "state": "Scotland"}, # Scotland bank hols
        {"country": "UnitedKingdom", "state": "Northern Ireland"}, # NI bank hols
        {"country": "Ireland", "state": None}, # Ireland bank hols
        {"country": "UnitedStates", "state": "NY"}, # USA, New York bank hols
        {"country": "UnitedStates", "state": "DC"} # USA, Washington DC bank hols 
    ]
    # get current year 
    current_year = dt.now().year 
    # calculate next year & prior year 
    prev_year = current_year - 1
    next_year = current_year + 1
    years_to_collate = [prev_year, current_year, next_year]

    # set an empty list to append dataframe objects into 
    df_list = [] 
    # loop through each combination of Country & State to collect its details 
    for lookup in countries_states:
    try:
        for year in years_to_collate:
            hols = holidays.CountryHoliday(lookup['country'], subdiv=lookup['state'], years=year)
            # convert to dataframe 
            holidays_df = pd.DataFrame(hols.items(), columns=['Date', 'Holiday'])
            holidays_df['Country'] = lookup['country']
            holidays_df['State'] = lookup['state']
            holidays_df['Year'] = year 
            holidays_df = holidays_df[['Year', 'Country', 'State', 'Date', 'Holiday']]
            df_list.append(holidays_df) 
            # wipe objects from memory for next iteration 
            del hols, holidays_df 
    except Exception as e:
        raise e 

    # combine all dataframe parts in the list, to oen dataframe through concat
    holidays_data = pd.conact(df_list)

    # read that pandas df into snowpark
    holidays_snowpark = (snowpark
        .createDataFrame(holidays_data)
        .rename(
            {
                '"Year"': "Year",
                '"Country"': "Country",
                '"State"': "State",
                '"Date"': "Date",
                '"Holiday"': "Holiday" 
            }
        )
    )

    # Cast Year & Date to correct data types 
    holidays_out = (holidays_snowpark
        .withColumn("Year", holidays_snowpark["Year"].cast(IntegerType()))
        .withColumn("Date", to_date(holidays_snowpark["Date"]))
        .orderBy(['Year', 'Country', 'State', 'Date'])
        .select("Year", "Country", "State", "Date", "Holiday")
    )

    # write data out from snowpark dataframe to snowflake table 
    holidays_out.write\
        .mode("overwrite")\
        .save_as_table("UTILITY_DATA_ASSETS.BANK_HOLIDAYS")

    # Return value 
    return "SUCCESSFULLY LOADED BANK HOLIDAYS DATA"
$$
;


-- With the above procedure created, we now need to create a task
-- The task can be set to run on a schedule, and call the above procedure at each run 
-- NOTE - a task is automatically suspended when created, so we need to then enable it after creation
CREATE OR REPLACE TASK RUN_BANK_HOLS_LOADER
WAREHOUSE="TEST_SF_WAREHOUSE" -- set warehouse to use when task will execute 
-- Cron schedules are set in format * * * * * 
-- minute(0-59), hour(0-23), day of month(1-31) or L(ast), Month(1-12 or JAN-DEC), day of week(0-6, SUN-SAT or L(ast))
-- set a simple pattern of every minute, every day, for this example worflow 
SCHEDULE='USING CRON * * * * * GMT' -- set with GMT timezone 
AS 
CALL UTILITY_DATA_ASSETS.RUN_BANKHOLS_SOURCE() ;

-- Show all tasks 
SHOW TASKS ;

-- You will see the task is currently suspended
-- Turn task on
ALTER TASK RUN_BANK_HOLS_LOADER RESUME ;

-- END    