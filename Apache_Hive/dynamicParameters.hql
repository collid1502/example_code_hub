-- The following script is an example of using a variable/parameter to substitute a value into a
-- Hive script for execution 

set hivevar:Use_Date=(
    SELECT
        MAX(business_date) 
    FROM
        schema.customer_main_addresses 
)
;

-- now run a query on said table, filtering based on the hivevar 
SELECT
    customer_id, customer_address, customer_postcode, business_date 
FROM
    schema.customer_main_address 
WHERE 
    business_date IN ${hivevar:Use_Date} 
; 
