-- This example allows us to use stored procedures to return a dataset

USE DATABASE "SAMPLE_DATABASE";
USE SCHEMA "CUSTOMER_SALES";

-- here, we wish to collect the sales history of a customer, based on their ID
CREATE OR REPLACE PROCEDURE collect_sales_history(customer_id integer)
RETURNS TABLE (
    customer_id integer, products array, transaction_ts varchar, transaction_amt number(20,2) 
)
LANGUAGE SQL AS 
$$
DECLARE 
    res RESULTSET;
BEGIN
    res := (
            SELECT DISTINCT 
                customer_id, products, transaction_ts, transaction_amt  
            FROM CUSTOMER_SALES.ALL_SALES
            WHERE customer_id = :customer_id
            ORDER BY customer_id, transaction_ts DESC
        );
    RETURN TABLE(res);
END;
$$
;

-- Example 
SELECT * FROM TABLE(collect_sales_history(12345));

-- end 