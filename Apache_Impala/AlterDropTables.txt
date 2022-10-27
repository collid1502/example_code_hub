-- alter an EXTERNAL TABLE to INTERNALLY MANAGED table on Hive Metastore via Impala 
-- Then, drop that table 
-- This will wipe actual data from HDFS, as well as just Hive table metadata 

ALTER TABLE schema.my_table SET tblproperties('EXTERNAL'='False') ;

DROP TABLE IF EXISTS schema.my_table ; 
