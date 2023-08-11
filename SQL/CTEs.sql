/**
CTEs - Common Table Expressions

These are like sub-queries, but can be a bit cleaner.
For example, you may have a situation where the same sub-query could be needed twice for a join you 
are trying to perform, well, a CTE would need only be specified once. It can then be called as if it 
were an actual table, meaning no need for repeating the code of the sub-query over and over 
**/

WITH cte_sales_amounts AS 
( 
    SELECT 
        CONCAT(first_name, " ", last_name) as FullName,
        SUM(quantity * list_price * (1 - discount)) as Sales,
        YEAR(order_date) as sales_year 
    FROM 
        schema.sales 
    GROUP BY 
        CONCAT(first_name, " ", last_name),
        YEAR(order_date) 
)

SELECT 
    FullName, Sales, sales_year 
FROM cte_sales_amounts
WHERE sales_year = 2022 
; 