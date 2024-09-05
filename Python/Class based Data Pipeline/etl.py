#============================================#
# Main ETL script to process API data        #
#============================================#

# Imports 
import yaml
import os 
from extract import API_Extract
from transformLoad import apiTransformLoad
from utils import logger
from api_metadata import api_etl_metadata 


# use metadata imported above, to drive the ETL workflow
def ETL(api_metadata: dict = api_etl_metadata):
    """ This is a function to orchestrate the ETL for data from API source to Snowflake target """
    #log = logger(output='file', level='DEBUG', filename='./test.log') # writes to a specified log file (example)
    log = logger() # use defaults to create logging object
    log.info("=" * 100)
    log.info("Read in credentials for ETL process ...")
    try:
        with open("configs.yml", "r") as configFile: # read in configuration file  
            configs = (yaml.safe_load(configFile))
            log.info("configs collected")
        api_key = os.getenv("api_key")                   # set the API key from hidden environment variable 
        domain = configs['api']['domain']                    # set the Target Domain
        connection_details = configs['snowflake details']          # collects the configs to authenticate a connection to snowflake with service acct
        connection_details['password'] = os.getenv("snowflake_pw") # collects password from hidden environment variable

        apiSchema = "API_DATA"                      # Target schema on snowflake 
        base_url = f"https://{domain}/api/v1/"      # set base url for requests Endpoint
        api_headers = {                             # headers for requests
            "Authorization": f"Bearer {api_key}",
            "Accept": "application/vnd.api+json",
            "Content-Type": "application/json"
        }
        log.info("ETL configurations set")
    except Exception as e:
        log.error(e)
        raise e 
    
    # Now, for each extract listed in the Metadata provided, we will conduct the ETL pattern from `transformLoad` 
    for extract, extract_metadata in api_metadata.items():
        try:
            log.info(f"Running {extract} build from API")
            target_url = base_url + extract_metadata['api_target'] 
            targetQueryParams = extract_metadata['queryParams']

            # instantiate a API Extract Class for this extract. This will pull JSON response data into memory
            api_extract = API_Extract(target_url, api_headers, targetQueryParams, log)
            api_extract_data = api_extract.load_all_pages() 
            api_extract.closeSession() # close API connection 
            log.info(f"{extract} data extracted. Rows: {len(api_extract_data)}")

            # instantiate Transform & Load class for this data extract 
            api_data_transformed = apiTransformLoad(connection_details, apiSchema, log)
            # now chain the ETL steps together by using methods from the class that was instantiated above 
            (api_data_transformed
                .build_dataset(
                    inputData=api_extract_data, # provide the input data as that of the extract generated above
                    target_table=extract, # provide the name of the target table on snowflake 
                    extract_cols=extract_metadata['extract_columns'], # provide the columns to keep from the API extract 
                    target_schema=extract_metadata['snowflakeSchema'] # provide the schema of the target snowflake table data should insert to
                )
                .wipe_old_data(extract)
                .close()
            )
            # wipe all objects created during loop iteration 
            del target_url, targetQueryParams, api_extract, api_extract_data, api_data_transformed
            log.info(f"{extract} publish to Snowflake complete")
            log.info("=" * 150)
        except Exception as e:
            log.error(e)
            raise e 
 
    ## END OF PIPELINE ---------------------------------------------------------------------------------------------->
    log.info("ALL API EXTRACTS COMPLETED")
    log.info("=" * 150)


if __name__ == "__main__":
    ETL() # executes the ETL flow
    