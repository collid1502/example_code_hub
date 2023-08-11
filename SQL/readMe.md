# SQL 

SQL is "Structured Query Language" 

It's commonly used for interacting with traditional RDBMS (Relational DataBase Management Systems) such as Oracle, MySQL, Postgres, Teradata, DB2 etc. 

It now also can be used in big data frameworks, like Apache Spark or Hive, for processing, joining or manipulating data as required.

This sub-folder contains multiple examples of typical queries, joins, aggregations, window functions, CTEs etc. which a user may wish to utilise through SQL.

Note, there are actually many different SQL dialects, but most have large cross-overs. 

#### Execution Order in SQL queries 

- `FROM`: The Tables that are joined or read to get the base data 
- `WHERE`: The base data is filtered 
- `GROUP BY`: The filtered base data is grouped 
- `HAVING`: The grouped data is filtered 
- `SELECT`: The final data is returned 
- `ORDER BY`: The final data returned is sorted 
- `LIMIT`: The returned data is limited to a row count (N) 