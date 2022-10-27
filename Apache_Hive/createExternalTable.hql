/*
Create an external table for storage on Hadoop
*/

Create External Table If Not Exists schema.table_name 
(
    CustomerID BIGINT,
    Sales_Amount DECIMAL(10,2),
    Sales_Date VARCHAR(20)
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\001' 
LINES TERMINATED BY '\n'
STORED AS TEXTFILE 
LOCATION 'some/hdfs/path/you/can/access/table_name' 
TBLPROPERTIES ("skip.header.line.count"="0") 
; 