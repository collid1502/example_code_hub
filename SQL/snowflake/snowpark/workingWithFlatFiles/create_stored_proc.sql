CREATE OR REPLACE PROCEDURE MY_SCHEMA.RUN_FLAT_FILES() 
RETURNS STRING 
LANGUAGE PYTHON 
RUNTIME_VERSION = '3.8'
PACKAGES = ('snowflake-snowpark-python') 
HANDLER = 'main'
EXECUTE AS CALLER -- required if you plan to use a Temp Table within your code, for example 
AS 
$$ 
# use Python 3.8
# imports 
import snowflake.snowpark as snowpark 
from snowflake.snowpark.functions import col, lit
from snowflake.snowpark.types import *
from snowflake.snowpark.files import SnowflakeFile 
import csv 


def main(snowpark: snowpark.Session):
    """
    This function will wrap into a stored proc, that is designed to process CSV files that are not text qualified and must be read line-by-line 
    It pushes each file to Snowpark DF, and then appends that DF to a snowflake table 
    """
    # create a list of all files within the stage that you wish to read & process in a loop
    file_list = (snowpark.sql("LIST @INTERNAL_STAGE.SUBFOLDER")).select(col('\"name\"')).collect() 
    for file in file_list:
        print(f"Running file {file[0]}")
        # open the file and return a snowflake file object 
        sf_file = (
            SnowflakeFile.open(
                f"@INTERNAL_STAGE.{file[0]}", 'r', require_scoped_url=False 
            )
        )
        # Read from open file with CSV reader 
        reader = csv.reader(sf_file, delimiter=',') # reader access files and uses comma delimiter, which creates a list of string objects per row, via a comma split 
        for row in range(0, 5): # skips the first 5 rows of each CSV that has no data (in this example) 
            next(reader) # next allows you to move to next row in the file stream 

        # now on line 6, which contains headers, read them and create object to hold them 
        headers = [element.strip() for element in next(reader)] # takes the list of strings from row 6, strips each string, and creates a new list called `headers` 
        master_data = [] # empty string that will have each row of data appended to it once processed/cleaned 

        for row in reader:
            # now, in this example, let's say we know that if no. of columns from a row matches that of headers, row is fine and can simply be appended
            if len(row) == len(headers):
                master_data.append(row) # everything should be clean and no issues
            elif len(row) < len(headers): # now this shouldn't happen, so raise an exception if it does 
                raise Exception(f"The number of columns in the row is less than the number of headers ...\nfile: {file}\nrow: {row}")
            else:
                # now, we've got to the stage where we found a case of more columns in a row, than headers. 
                # this is the non-text-qualified comma issue we are trying to account for
                # creating a simple example, let's say we expect 4 cols max, and we know col1 is a filename we can split a string by ...
                text_row = ",".join(row) # creates one ling string, comma separated, of all the elements in the list `row` 
                # find the \\ pattern in the string (escaped by two further \\) which if we take the text to the left of this pattern, at first occurence, will be file/folder name & any erroneous comma
                path_index = text_row.upper().find("\\\\") # this indicates the position in string pattern is found at 
                name_clean = (text_row[0:path_index])[0:-1] # keep string from char 0 to path_index value, then remove last char which is a trailing character 
                remaining_text = str(text_row[path_index:]) # keeps all text from path_index to the end of the string, and places that into a new object to be processed next
                # now, use `name_clean` to delimiter the next string and find the full directory path 
                full_path_index = remaining_text.find(name_clean) 
                full_path = (remaining_text[0:full_path_index]) 
                full_path_clean = full_path + name_clean 

                remaining_text_2 = (remaining_text[full_path_index:]).replace(name_clean, '') 
                remaining_text_3 = remaining_text_2.replace(full_path, '') 

                # so thats 2 columsn down. Let's just assume we now know whatever is remaining cannot contain commas in their data, thus, the only commas
                # we can come across in the string are actual delimiters, hence teh remaining string can be cleanly split by `,`
                remaining_cols = (remaining_text_3.split(sep=','))[1:] # now we can use list indices to align the values to correct column headers
                size = remaining_cols[0]
                owner = remaining_cols[1] 
                # place the 4 cleaned objects into a cleaned data row list 
                clean_data_row = [
                    name_clean, full_path_clean, size, owner 
                ]
                master_data.append(clean_data_row) # everything should be clean and no issues
            # ---> process next row 
        # when done, close the file 
        sf_file.close() 

        # ok, now we have the data in a list of lists, we can push it to a snowpark dataframe 
        useSchema = StructType([
            StructField("FILENAME", StringType()),
            StructField("FULLPATH", StringType()),
            StructField("SIZE", StringType()),
            StructField("OWNER", StringType())
        ])
        snowDF = snowpark.create_dataframe(master_data, schema=useSchema) # reads data into snowpark DF 
        snow_df_w_source = snowDF.with_column('SOURCE_FILE', lit(str(file[0])))
        # now append to snowflake table that already exists 
        snow_df_w_source.write.mode("append").save_as_table("MY_SCHEMA.MY_TABLE") 

    return 'SUCCESS' # the main handler function returns this string if all succeeds 
$$;

-- exit snowcli once done 
!exit ;