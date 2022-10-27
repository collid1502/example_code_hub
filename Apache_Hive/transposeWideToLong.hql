-- Tranpose WIDE to LONG is when you have data across multiple columns,
-- but you wish for that data to be turned into one column on multiple rows.
-- An example may be like the following:

-- you have a customer marketing permissions table that looks like this

-- --------------------------------------------------------------------------------------|
-- CustomerID   |       Email     |    Mobile    |   Email            |   SMS            |
-- --------------------------------------------------------------------------------------|
-- 12345        | dummy@email.com |  77777777    |  Yes               |  Yes             |
-- 23456        | dummy@email.com |  77777777    |  No                |  Yes             |
-- 34567        | dummy@email.com |  77777777    |  Yes               |  No              |
-- --------------------------------------------------------------------------------------|

-- you wish to get a dataset where for each customer, you have the marketing type, and it's Y/N value, like:

-- -------------------------------------------|
-- CustomerID   |     Key       |    Value    |
-- -------------------------------------------|
-- 12345        | Email         |  Yes        | 
-- 12345        | SMS           |  Yes        |  
-- 23456        | Email         |  No         | 
-- 23456        | SMS           |  Yes        | 
-- -------------------------------------------| 

SELECT 
    t1.CustomerID,
    t2.Key,
    t2.Value 
FROM 
    schema.customer_marketing
    LATERAL VIEW EXPLODE
        (MAP(
            'Email', Email, 
            'SMS', SMS
        )) t2 as Key, Value 
WHERE t2.Value IN ('Yes', 'No') -- showing example filter can also be applied on the map explosion 
;
