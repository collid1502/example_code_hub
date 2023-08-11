/**
Unions

Unions in SQL allow for the combination of two result sets from select statements.
Think of this combination like stacking, one dataset on top of another, to make one larger dataset

In order for this to work:

- every SELECT statement within the UNION must have the same number of columns 
- The columns must have similar data types 
- The columns should be in the same order 

UNION vs UNION ALL

UNION by default will remove any duplicate rows that exist after the combination.
Should you need to keep the duplicates, UNION ALL can be used.

**/ 

SELECT 
    a.col1, a.col2, a.col3 
FROM 
    schema.customers_1 as a 
UNION 
SELECT 
    b.col1, b.col2, b.col3 
FROM 
    schema.customers_2 as b 
; 