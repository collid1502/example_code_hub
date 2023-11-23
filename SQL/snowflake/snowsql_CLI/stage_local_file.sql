-- This file must be run via the SnowSQL CLI
-- create a stage
create or replace stage dummy_data_test
file_format = (type = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);

-- copy DummyData.csv to created stage
PUT file://yourLocation\DummyData.csv @~/dummy_data_test
AUTO_COMPRESS = TRUE -- set autocompress to true
OVERWRITE = TRUE -- ensure file overwrites existing file of this name if is already in stage
;

-- list staged data files to confirm it's there
LIST @~/dummy_data_test ;

-- drop table if exists, create empty table schema, which will then copy data from file into 
DROP TABLE IF EXISTS PUBLIC.LOCAL_FILE_STAGE_TEST ;
CREATE TABLE PUBLIC.LOCAL_FILE_STAGE_TEST
(
    NAME VARCHAR(100) NOT NULL,
    CLASS CHAR(1) NOT NULL,
    SCORE_100 INTEGER
);

-- show tables to confirm its there
SHOW TABLES IN SCHEMA PUBLIC ;

-- now that we have the table, copy data from the stage into it
COPY INTO PUBLIC.LOCAL_FILE_STAGE_TEST
FROM @~/dummy_data_test file_format = (type = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);

-- query table to ensure data is there and order by scores desc, limit top 5
SELECT * FROM PUBLIC.LOCAL_FILE_STAGE_TEST ORDER BY SCORE_100 DESC LIMIT 5;

-- with this complete, you can exit the SnowSQL CLI
!exit