/**
Window Functions

These can be useful for doing in-query aggregations or operations, reducing the need for multiple joins
An example here will be collecting a customer's current balance, and the previous day's balance, from one
table, so that they are on the same row, and we can calculate the balance movement in 24 hours for each
customer in the table 
**/ 

SELECT  
    latest_balances.CustomerID,
    latest_balances.Balance_Date,
    latest_balances.Current_Balance,
    SUM(latest_balances.Current_Balance, -(latest_balances.Previous_Balance)) as Balance_Change_24hrs 
FROM 
(
    SELECT 
        a.CustomerID,
        a.Balance_Date,
        a.Current_Balance,
        LAG(a.Current_Balance, 1) OVER (PARTITION BY a.CustomerID ORDER BY a.CustomerID, a.Balance_Date) as Previous_Balance
    FROM 
        schema.customer_balances as a 
    WHERE balance_date BETWEEN '2022-01-01' AND '2022-01-02'
) AS latest_balances 
WHERE latest_balances.Current_Balance > 0  
;
