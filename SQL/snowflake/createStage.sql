-- This is a simple example to look at creating an `internal` stage on Snowflake
-- This allows you to store data files internally within snowflake and they can
-- be either perm or temp

-- list current user stages 
LIST @~ ;


-- DROP STAGE 
CREATE OR REPLACE STAGE dummy_csv_stage
file_format = (type = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);

-- Note, for staging "local" data, i.e. a file from an on-premise server/shared drive, you would
-- need to run the `PUT` via a SnowSQL CLI command from where that data is.
-- See snowsql_cli folder for an example.