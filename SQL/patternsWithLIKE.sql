/**
Pattern matching for where clauses can be really useful, and this can commonly be done
using the LIKE method in SQL

below is a generic example
**/

SELECT
    CustomerName, Customer_Age, Customer_Type
FROM 
    schema.Customers 
WHERE CustomerName LIKE 'a%' 
;
/** The above example would return any customer name starting with the letter 'a' **/

/** OTHER EXAMPLES 

WHERE CustomerName LIKE '%a' - finds any value ending in 'a' 
WHERE CustomerName LIKE '%or%' - finds any value that has 'or' in any position 
WHERE CustomerName LIKE '_r%' - finds any value where 'r' is in the second position 
WHERE CustomerName LIKE 'a_%' - finds any value starting with 'a' and is at least 2 characters in length 
WHERE CustomerName LIKE 'a__%' - same as above, but at least 3 chars in length 
WHERE CustomerName LIKE 'a%o' - finds any value that starts with 'a' and ends with 'o' 