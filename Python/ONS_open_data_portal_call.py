# ## Connecting to ONS Open Data Portal ~ Postcode Lookup 
# 
# Author: `Dan Collins` 
# Last Updated: `19/01/2022` 
# This script collects postcodes & other metadata from the UK ONS open data portal through their endpoint

# key imports 
import requests
import pandas as pd 
import numpy as np 

# remove column cap on Pandas outputs
pd.set_option('max_columns', None) 

# First stage, use the requests lib to poll the ONS Postcode Directory for the number of "Object IDs" ~ aka Postocdes
# We do this, as there is a call limit to the API which caps out at 50,000 (but not for Record IDs). So, we can loop through Object IDs to collect all postcodes after

ons_postcode_query = r"""
https://ons-inspire.esriuk.com/arcgis/rest/services/Postcodes/ONS_Postcode_Directory_Latest_Centroids/MapServer/0/query?where=1%3D1&outFields=pcd,dointr,doterm,ctry,rgn,lat,long&outSR=4326&f=json&returnIdsOnly=true
"""

response = requests.get(ons_postcode_query).json() 

postcode_object_ids = pd.json_normalize(response, 'objectIds') 

postcode_vol = len(postcode_object_ids) 

print()
print("Number of postcodes found: " + f"{postcode_vol:,}")
print()


# with the number of Object IDs now known - we will loop through in batches of 100 to call from the API 
# seems to be some performance issues if going above batches of 100, tested 500 and hit a few issues, but maybe it was a one off ...

#dummy = 500000       # a test of 500,000 postcodes took c.20 minutes
loop_counter = 0 

# empty list for Pandas DFs
all_dfs = [] 

# postcode JSON query for calling data from endpoint
pcd_api_call = r"""
https://ons-inspire.esriuk.com/arcgis/rest/services/Postcodes/ONS_Postcode_Directory_Latest_Centroids/MapServer/0/query?where=1%3D1&outFields=pcd,dointr,doterm,oslaua,osward,ctry,rgn,pct,lsoa01,lat,long&outSR=4326&f=json&objectIds=
"""

# the loop, will add a custom list of Object IDs (in a batch) onto the JSON query template above, to bring back into a pandas DF
# all these pandas df's can then be concated into a single large DF, containing all postcodes
while loop_counter <= postcode_vol:

    # steps to do 
    obj_id_str = ",".join([str(i) for i in range((loop_counter + 1), (loop_counter + 101))])
    custom_json_qry = str(pcd_api_call + obj_id_str).replace(" ", "") 

    # collect API response 
    api_response = requests.get(custom_json_qry).json() 
    #print(requests.get(custom_json_qry).status_code)  # TESTING ~ 200 indicates successful call 

    # convert to pandas df format ~ 'features' is essentially the sub-heading of JSON string for all fields we are calling from the API
    df = pd.json_normalize(api_response, 'features') 

    # append into list 
    all_dfs.append(df) 

    # add to loop counter 
    loop_counter = loop_counter + 100



uk_postcodes = pd.concat(all_dfs, axis=0).reset_index() 
#uk_postcodes.sample(n=5)



"""
define series of functions to translate codes to actual values per ONS open Data Portal guides
"""
# dates which come in YYYYMM format only and ad '01' for first day of month 
def date_clean(r):
    if r != None:
        r = r + "01" 
    return r


# -----------------------------------------------------------------------------------------------


# changes country codes to actual values 
def country_clean(r):
    if r.replace(" ", "") == 'E92000001':
        r = 'England' 
    elif r.replace(" ", "") == 'W92000004':
        r = 'Wales'
    elif r.replace(" ", "") == 'S92000003':
        r = 'Scotland'       
    elif r.replace(" ", "") == 'N92000002':
        r = 'Northern Ireland'   
    elif r.replace(" ", "") == 'L93000001':
        r = 'Channel Islands'
    elif r.replace(" ", "") == 'M83000003':
        r = 'Isle of Man'

    return r


# -----------------------------------------------------------------------------------------------


# changes region codes to actual values 
def region_clean(r):
    if r.replace(" ", "") == "E12000001":
        r = 'North East' 
    elif r.replace(" ", "") == "E12000002":
        r = 'North West' 
    elif r.replace(" ", "") == "E12000003":
        r = 'Yorkshire and The Humber' 
    elif r.replace(" ", "") == "E12000004":
        r = 'East Midlands' 
    elif r.replace(" ", "") == "E12000005":
        r = 'West Midlands' 
    elif r.replace(" ", "") == "E12000006":
        r = 'East of England' 
    elif r.replace(" ", "") == "E12000007":
        r = 'London' 
    elif r.replace(" ", "") == "E12000008":
        r = 'South East' 
    elif r.replace(" ", "") == "E12000009":
        r = 'South West' 
    elif r.replace(" ", "") == "W99999999":
        r = 'Wales' 
    elif r.replace(" ", "") == "S99999999":
        r = 'Scotland' 
    elif r.replace(" ", "") == "N99999999":
        r = 'Northern Ireland' 
    elif r.replace(" ", "") == "L99999999":
        r = 'Channel Islands' 
    elif r.replace(" ", "") == "M99999999":
        r = 'Isle of Man' 
    else:
        r = None 

    return r



# apply above functions
uk_postcodes['country'] = uk_postcodes.apply(lambda row: country_clean(row['attributes.ctry']), axis=1) 
uk_postcodes['introduced'] = uk_postcodes.apply(lambda row: date_clean(row['attributes.dointr']), axis=1) 
uk_postcodes['terminated'] = uk_postcodes.apply(lambda row: date_clean(row['attributes.doterm']), axis=1) 
uk_postcodes['region'] = uk_postcodes.apply(lambda row: region_clean(row['attributes.rgn']), axis=1) 
uk_postcodes2 = uk_postcodes.rename(columns={'attributes.pcd': 'postcode', 'attributes.lat': 'latitude','attributes.long': 'longitude'})

keep_cols = ["postcode", "introduced", "terminated", "country", "region", "latitude", "longitude"]
ons_postcodes_data = uk_postcodes2[keep_cols] 


# final data frame 
ons_postcodes_data.sample(n=10) 

#  End