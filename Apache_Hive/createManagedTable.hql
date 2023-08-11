/**
Example - create managed, partitioned table & insert into it from results of a query 
*/

CREATE TABLE IF NOT EXISTS schema.my_table 
(
    CUSTOMER_NAME VARCHAR(20),
    CUSTOMER_AGE INT,
    CUSTOMER_ADDRESS STRING
)
COMMENT 'CUSTOMER DETAILS TABLE' 
PARTITIONED BY(BRAND CHAR(5), BUSINESS_DATE VARCHAR(20)) 
;

/* Insert data to table above from results of a select query on another table */ 
INSERT INTO TABLE schema.my_table
PARTITION(BRAND, BUSINESS_DATE)
SELECT 
    CONCAT(FIRST_NAME, " ", LAST_NAME) AS CUSTOMER_NAME,
    CUSTOMER_AGE,
    CONCAT(CUSTOMER_ADDRESS, " ", CUSTOMER_POSTCODE) AS ADDRESS 
FROM 
schema.all_customer_details 
; 