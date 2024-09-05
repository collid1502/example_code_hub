""" 
Script to execute some standard DQ checks against data.
This makes use of open source frame `cuallee` which is *mostly* dataframe agnostic.
Uses snowpark connection to hit table, run checks, save results & log any key concerns or breaking changes.
"""

# Imports
import logging
import yaml 
import os 
import pandas as pd 
import duckdb as ddb
from snowflake.snowpark import Session 
from snowflake.snowpark.functions import *
from cuallee import Check, CheckLevel   


# Create a logging decorator to apply to function(s) within the process 
def logger(output: str = 'terminal', level: str = 'INFO', filename: str = None) -> object:
    """Simple function to return a logging object, that lets you flip between logging messages to the terminal or to a file.

    Args:
        output (str, optional): Specify 'terminal' or 'file' as to direct where log messages should go. Defaults to 'terminal'.
        level (str, optional): Set the logging level to be applied. Defaults to 'INFO'.
        filename (str, optional): If 'file' chosen as output, provide .log file to write messages to. Defaults to None.

    Returns:
        object: returns an object which contains the handler for log statements.
    """
    # configure logging 
    logger = logging.getLogger() 
    eval(f"logger.setLevel(logging.{level})") # evaluates the logging level provided & sets it 
    # Determine whether to log to the terminal, or to a provided file name based on input argument
    # first check that either "terminal" or "file" provided 
    if output != "terminal" and output != "file":
        raise ValueError("Please specify a value of `terminal` or `file` for the output argument")
    elif output == "file":
        if filename == None:
            raise ValueError("File output for logging specified, but no target filename provided. Please provide a \{name\}.log file")
        handler = logging.FileHandler(filename, mode='a') # explicit set to append mode for any "filename" passed in
    else:
        handler = logging.StreamHandler(stream=sys.stdout) 
    # set formatter for log entries
    formatter = logging.Formatter('%(asctime)s -- %(levelname)s : %(message)s') 
    handler.setFormatter(formatter) 
    logger.addHandler(handler) 
    return logger


# create function to read configurations from YAML config file and pass to dictionary object
def yaml_configs(path: str) -> dict:
    """Reads yaml file and pushes data from it into a dictionary

    Args:
        path (str): path to the configs .yaml file

    Returns:
        dict: returns object with data from YAML file into dictionary object 
    """
    with open(path, "r") as configFile:
        configs = yaml.safe_load(configFile)
        return configs 
    

# create function to launch a Snowpark connection, to a remote snowflake instance 
def getSnowpark(connection_details: dict) -> object:
    """Use the connection details provided from input dictionary and create a snowpark session, returning an object that links to snowflake.

    Args:
        connection_details (dict): Provide details to connect to snowflake via snowpark 

    Returns:
        object: snowpark. An object to access remote snowflake compute and services etc. 
    """
    if isinstance(connection_details, dict) == False:
        raise TypeError("`connection_details` provided is not a dictionary object") 
    snowpark = Session.builder.configs(connection_details).create() # creates an object which will refer to remote snowflake compute
    return snowpark 


# Create a generic function that checks if there are any failures in DQ checks, and if so, throw an error
def failed_checks(input_dq_results: object):
    con = ddb.connect() # duckDB connection in-memory
    con.register('DQ_RESULTS', input_dq_results) # sets the input dataframe to a registered table
    dq_fails = (
        con.execute("""
        SELECT 
            SUM(CASE WHEN STATUS = 'FAIL' THEN 1 ELSE 0 END) AS DQ_FAILURES
        FROM DQ_RESULTS
        """).df().iloc[0, 0] # accesses the actual value 
    )
    con.close() # close duckdb in-memory connection
    if dq_fails != 0:
        raise Exception("Data Quality checks have FAILED. See Logs for details")
    else:
        return None


# Create an Example DQ check that can run on Snowflake Tables / Datasets
def example_actions_dq(snowpark: object, targetTable: str = "schema.table"):
    """Uses the `cuallee` package to run some DQ checks on a dataframe, through Snowflake connector

    Returns:
        DQ check results
    """
    # checks
    dq_checks = Check(
        level=CheckLevel.ERROR, 
        name="schema.table Data Quality Checks",
        table_name = "OSX ACTIONS RAW",
        session=snowpark
    )
    # read table into snowpark dataframe & push to pandas for local operation 
    input_df = snowpark.table(targetTable).toPandas() 
    # add in checks, then validate against test dataframe 
    dq_results = (dq_checks
        .is_complete("User ID")
        .is_complete("User - Created Date")
        .is_complete("User - DOB")
        .is_contained_in("User - Deleted Flag", ['Y', 'N']) 
        .validate(input_df)
    )
    del input_df
    return dq_results


# driver function to orchestrate workflow
def main():
    """Drives the worflow of DQ checks"""
    log = logger(output='terminal', level='INFO') # set up logging object - logs to go to terminal
    log.info("=" * 150) 
    log.info("Read in config yaml file")
    configs = yaml_configs(path="./appConfigs.yaml") # start by reading in config files
    log.info("Read in service credentials configs")

    # With those configs read in, we can pull the snowflake connection details from `configs`
    # we can then use `credentials` to update the password {key} value in that dictionary
    log.info("Collect Snowflake Connection Details")
    snowflake_conn_deets = configs['SNOWFLAKE CONNECTION DETAILS'] 
    log.info("Update `password` in connection details from secret credentials file") 
    snowflake_conn_deets['password'] = os.getenv("snowflake_pw") 
    # Start a Snowpark session, so that we have access to remote snowflake compute & data through Python 
    log.info("Starting Snowpark Session ...")
    try:
        snowpark = getSnowpark(connection_details=snowflake_conn_deets)
        log.info("Snowpark Session Started")
    except Exception as e:
        log.error(e, exc_info=True)
        raise e
    
    # test DQ example
    log.info("Run Data Quality on data ...")
    actions_dq = example_actions_dq(snowpark=snowpark)
    log.info(f"\n{actions_dq.to_string()}\n")
    failed_checks(actions_dq) # will raise an exception if DQ checks have a FAILURE
    log.info("DQ checks have passed")

    log.info("End of Data Quality checks")
    snowpark.close()
    log.info("=" * 150)
    return None 


# executes main() when script is called 
if __name__ == "__main__":
    main() # executes program flow of DQ checks 
