-- This example will perform a transpose (think pivot of data) from a dataset which is 
-- LONG to one which is WIDE

-- An example of this would be, a table containing customer's and their citizenship records,
-- where a customer can have multiple rows, one for each citizenship they hold

-- this example will transpose the data to have only one line per customer, but with multiple
-- columns, each of those columns containing a citizenship or NULL 

SELECT 
    c.customerID,
    CONCAT('', c.add_ctzn_1) as addl_citizenship_1,
    CONCAT('', c.add_ctzn_2) as addl_citizenship_2,
    CONCAT('', c.add_ctzn_3) as addl_citizenship_3,
    CONCAT('', c.add_ctzn_4) as addl_citizenship_4 
FROM 
(
    SELECT 
        b.customerID,
        COLLECT_LIST(b.group_map[1]) as add_ctzn_1,
        COLLECT_LIST(b.group_map[2]) as add_ctzn_2,
        COLLECT_LIST(b.group_map[3]) as add_ctzn_3,
        COLLECT_LIST(b.group_map[4]) as add_ctzn_4 
    FROM
    (
        SELECT 
            a.customerID,
            MAP(a.ctzn_, a.addnl_citizenship) as group_map 
        FROM
        (
            SELECT 
                customerID, addnl_citizenship,
                ROW_NUMBER() OVER (PARTITION BY customerID ORDER BY recordID) as ctzn_ 
            FROM 
                schema.customer_citizenship_records 
            WHERE business_date = '2022-01-01' 
        ) as a 
    ) as b 
) as c 
;
