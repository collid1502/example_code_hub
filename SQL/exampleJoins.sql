/** 
Simple Left Outer Join example 

Here, we retain all records from Table1, and we join on any records from Table2 where
Col1 from Table1 matches Col2 from Table2 
This example also creates a new column, which has a Y or N vakue depending on the match  
**/
SELECT
    a.col1,
    a.col2,
    b.col1
    CASE WHEN a.col1 = b.col1 THEN 'Y' ELSE 'N' END AS new_col 

FROM 
    schema.table1 as a 
LEFT JOIN 
    schema.table2 as b 
ON 
    a.col1 = b.col1 
ORDER BY a.col1, a.col2 
; 


/** 
Simple Inner Join example 

Here, we retain all records from both tables provided that a.col1 & b.col1 match  
**/
SELECT
    a.col1,
    a.col2,
    b.col1,
    b.col2 

FROM 
    schema.table1 as a 
INNER JOIN 
    schema.table2 as b 
ON 
    a.col1 = b.col1 
ORDER BY a.col1, a.col2 
; 


/** 
Simple Right Outer Join example 

Keeps all records from Table2, and brings back any matching records from Table1,
based on the Join Condition  
**/
SELECT
    a.col1,
    a.col2,
    b.col1 

FROM 
    schema.table1 as a 
RIGHT JOIN 
    schema.table2 as b 
ON 
    a.col1 = b.col1 
ORDER BY a.col1, a.col2 
; 


/** 
Simple Full Outer Join example 

returns all records, where there is a match in either left or right table 
**/
SELECT
    a.col1,
    a.col2,
    b.col1,
    b.col2,
    CASE WHEN a.col1 = b.col1 THEN 'Y' ELSE 'N' END AS new_col 

FROM 
    schema.table1 as a 
FULL OUTER JOIN 
    schema.table2 as b 
ON 
    a.col1 = b.col1 
ORDER BY a.col1, a.col2 
; 


/**
Simple Self Join Example 

a self join is simply a regular join, but the table is joined to itself 
**/
SELECT
    a.col1,
    b.col2 
FROM 
    table1 as a, table1 as b 
WHERE b.col2 > 0 
ORDER BY a.col1 
; 


/** 
Simple Cartesian (or Cross) Join Example 

here, a join exists for every row of a table to every row of some other table. 
usually occurs when the matching column isn't specified or when the WHERE condition isn't 

*NOTE* - These joins should be avoided unless really required. With two or more big tables, you'll hit issues!
Typical examples of when to use could be if you had one table with a list of customer IDs, and another table
with a list of days of the week, and you wanted a table that had each customer ID with every weekday against it,
to then do some further manipulation to. 
Here, no natural join key exists, so a cartesian could be used. 
**/
SELECT 
    a.CustomerID,
    b.DayOfWeek
FROM
    schema.Customers as a,
    schema.Weekdays as b 
ORDER BY 
    a.CustomerID, b.DayOfWeek 
; 