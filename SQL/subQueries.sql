/**
A sub-query is basically a nested SQL query.
For example, you wish to select a sub-set of one table, before joining with another.
Or, maybe join two tables, before joining the result with a third table etc etc

You can nest multiple times, but be aware, it can become "messy" and hard to debug / follow 
if you do!
**/

SELECT 
    young_customers.CustomerID,
    young_customers.Customer_Age,
    customer_sales.Total_Sales_YTD 

FROM 
    (SELECT DISTINCT 
        CustomerID, Customer_Age
    FROM schema.Customers
    WHERE Customer_Age BETWEEN 18 AND 30
    ) AS young_customers 

LEFT JOIN 
    (SELECT 
        CustomerID,
        SUM(sales_amt) as Total_Sales_YTD 
    FROM schema.Sales 
    WHERE sale_date > '2022-01-01' 
    GROUP BY CustomerID 
    ) AS customer_sales 

ON 
young_customers.CustomerID = customer_sales.CustomerID 

ORDER BY young_customers.CustomerID 
; 
