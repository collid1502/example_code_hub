# create a generic module for transforming API responses into Snowpark DataFrames & loading to snowflake

# Imports
import logging 
from snowflake.snowpark import Session 
from snowflake.snowpark.functions import current_date 
from snowflake.snowpark.types import IntegerType, StringType, StructType, \
    StructField, ArrayType, TimestampType, BooleanType, VariantType


# Create a transformation class that will contain some standard methods for snowpark setup & writing data
class apiTransformLoad():
    # Initialse the input of a list of JSON responses from the Extract class & snowflake credentials to build a snowpark connection
    def __init__(self, snowflakeCredentials: dict, targetSchema: str, log: object = None):
        """Initialises the API Transform class, with snowflake credentials

        Args:
            `snowflakeCredentials (dict)`: Dictionary containing key-value mappings for snowflake credentials to establish snowpark connection
            `targetSchema (str)`: Contains the schema within Snowflake that all data should be written to
            `log (obj)`: Contains a logging object that log messages can be written to, provided by user. Default is None.

        Raises:
            `ValueError`: When snowflakeCredentials is not submitted as a dictionary object 
        """
        if log == None: # determine if log object provided by user, or create a standard one that logs to nowhere
            self.log = logging.getLogger()
        else:
            self.log = log 
        self.targetSchema = targetSchema
        self.snowflakeCredentials = snowflakeCredentials
        if isinstance(self.snowflakeCredentials, dict) == False:
            raise ValueError(f"You have NOT provided the `snowflakeCredentials` argument with a \
                             dictionary object in {apiTransformLoad.__name__}. Please submit as a dictionary")
        self.snowpark = self.getSnowpark() # creates a snowpark connection that can be used throughout class when instantiated


    # create method for initialising snowflake creds into a snowpark connection 
    def getSnowpark(self):
        """Return an object that holds the remote connection to Snowflake via Snowpark"""
        snowpark = Session.builder.configs(self.snowflakeCredentials).create() 
        return snowpark


    # write dataframe to Snowflake 
    def loadData(self, inputDF: object, tableName: str, targetSchema: str = None, mode: str = "append"):
        """Takes an input dataframe, and saves it to snowflake"""
        if targetSchema == None:
            saveTo = f"{self.targetSchema}.{tableName}"
        else:
            saveTo = f"{targetSchema}.{tableName}"
        self.log.info(f"Writing data to snowflake ... {saveTo}") 
        try:
            inputDF.write.mode(mode).save_as_table(saveTo) # executes the save of data to Snowflake Target
            self.log.info("Data Loaded")
        except Exception as e:
            self.log.error(e)
            raise e         


    # create method to wipe data older than N months from target schema & table based upon extract date 
    def wipe_old_data(self, tableName: str, targetSchema: str = None, months: int = 12):
        """Wipes any extract date that from target table, that is older than months argument specified

        Args:
            tableName (str): target table name on snowflake to execute clean against
            targetSchema (str, optional): Schema table sits in. Defaults to None & uses target schema from class
            months (int, optional): Number of months prior to today, for which to drop and data older than. Defaults to 12.

        Raises:
            ValueError: Not providing an integer to months
            ValueError: Not providing a value greater than or equal to zero 
        """
        self.log.info(f"Running deletion of data older than {months} months from target: {tableName}")
        if isinstance(months, int) == False:
            self.log.error("You have supplied an argument to `months` that is not an integer. Please specify an integer")
            raise ValueError("You have supplied an argument to `months` that is not an integer. Please specify an integer") 
        if months < 0:
            self.log.error("You must specify a months value greater than or equal to zero")
            raise ValueError("You must specify a months value greater than or equal to zero")
        if targetSchema == None:
            targetTable = f"{self.targetSchema}.{tableName}"
        else:
            targetTable = f"{targetSchema}.{tableName}"
        drop = f"""
        DELETE FROM {targetTable} WHERE Extract_Date < add_months(current_date(), -({months}))
        """ 
        try:
            (self.snowpark).sql(drop).collect() 
            self.log.info("Deletion complete")
        except Exception as e:
            self.log.error(e)
            raise e 
        self.log.info("Historic data wiped from table")   
        return self # returns the instantiated class object (allows for method chaining)


    # create method to close Snowpark Connection
    def close(self, session: object = None):
        """Closes the Snowpark Object that is running via the `getSnowpark()` method in this class"""
        if session == None:
            (self.snowpark).close() # closes the snowpark connection
        else:
            session.close() # closes the snowpark connection 
        return self # returns the instantiated class object (allows for method chaining)
    

    def append_extract(self, table_name: str, build_data: list, build_schema: object):
        """Will create a snowpark df, add today's date as an extract_date field, then append to existing table

        Args:
            build_data (list): The data that will create a snowpark dataframe, as a list object
        """
        sp = (self.snowpark) # use snowpark session
        self.log.info(f"Push {table_name} Response Data to SnowPark Dataframe")
        try:
            sf_data = sp.create_dataframe(data=build_data, schema=build_schema) # creates data into dataframe
            self.log.info(f"Transforming {table_name} data")
            sf_data_w_date = (
                sf_data
                .with_column( # new column, that contains "Today's date" - which will be called extract date
                    "Extract_Date",
                    current_date() 
                )
            )
            # drop any existing data for extract date in target
            sp.sql(f"DELETE FROM {self.targetSchema}.{table_name} WHERE Extract_Date = CURRENT_DATE()")
            self.loadData(sf_data_w_date, table_name, self.targetSchema, "append") # write new data to snowflake
            self.log.info(f"Data loaded to target {table_name}")
            del sf_data, sf_data_w_date 
        except Exception as e:
            self.log.error(e)
            raise e  


    # create a method to build a snowpark df, & write to relevant snowflake table
    def build_dataset(self, inputData: list, target_table: str, extract_cols: list, target_schema: object):
        """Creates a snowpark dataframe, from the API response, which then gets written to snowflake, through snowpark.

        Args:
            `inputData (list)`: List of JSON responses data from API
            `target_table (str)`: Name of the target table on snowflake data should be written to
            `extract_cols (list)`: List of columns to keep from the API extract

        Raises:
            `ValueError`: When inputData is not submitted as a list object
        """
        if isinstance(inputData, list) == False:
            raise ValueError(f"You have NOT provided the `inputData` argument with a list \
                             object in {self.build_dataset.__name__}. Please submit as a list") 
        try:
            api_data_build = [] # create an empty placeholder. We will build a list, of rows of data
            for row in inputData: # iterate over the inputData we provide, row by row
                api_cols = [] # create an empty list, that will end up storing all the columns to keep
                for col in extract_cols: # for each of our listed columns to keep, in provided metadata, loop over
                    api_cols.append(row[col]) # add the column (from the row) to the empty api_cols list above
                api_data_build.append(api_cols) # now we have a row of data, aka api_cols, append that to the empty api_data_build list
                del api_cols # then, wipe the api_cols from memory, and start again for the next row of input data till finished 
        except Exception as e:
            self.log.error(e) # logs any error that gets caught via Exception 
            raise e  # and then also raises the error to stop the process
        self.append_extract(target_table, api_data_build, target_schema) # call the append_extract method to write to snowflake 
        del api_data_build
        return self # returns the instantiated class object (allows for method chaining)

