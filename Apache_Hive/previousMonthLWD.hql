-- This script is an example of calcukating the last business day of the 
-- previous month (from TODAY), and setting that value inside a WHERE clause, as to filter a table
-- within a query, to achieve the results for that previous time period, without needing
-- to run a separate query first to establish the date in question 

SELECT 
    business_date,
    customerID,
    accountNumber,
    Outstanding_Balance

FROM
    schema.customer_account_balances 
WHERE 
    business_date = if(
        extract(dayofweek from (last_day(add_months(current_date, -1)))) = 7,
        date_sub(last_day(add_months(current_date, -1)), 1),
        if(extract(dayofweek from (last_day(add_months(current_date, -1)))) = 1,
        date_sub(last_day(add_months(current_date, -1)), 2),
    )
;
