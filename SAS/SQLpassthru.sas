/*
SQL passthru is a powerful tool that allows SAS to connect to a remote database, push work 
down to that database, and bring back a query result to SAS work lib. This allows SAS to act as 
a proxy "virtualisation" layer, bringing multiple disparate data sources to one location
to join them together for future / downstream tasks 

This script covers some templated examples of connections via passthru.
Typically: Teradata, Impala & Hive

But the principle remains the same ince a connection is established. 
NOTE - The inner query must match the SQL dialect of the remote database
*/

/* SAS to Teradata example */
PROC SQL;
    CONNECT TO TERADATA
    (SERVER="<insert_your_server>" DATABASE="<insert_db_name>" USER="<your_db_username>" PASSWORD="<you_pw>" MODE=TERADATA);
    CREATE TABLE 
        CUSTOMER_ACCOUNTS 
    AS SELECT 
        CUSTOMERID,
        INPUT(ACCOUNT_OPENED_DATE, YYMMDD10.) ACCT_OPENED FORMAT DATE9., /* changes number to date */
        ACCOUNT_NUMBER,
        SORTCODE,
        CURRENT_BALANCE

    FROM CONNECTION TO TERADATA
    /* now everything inside this subquery, must be able to run on the remote DB connecting to */
    (
        SELECT 
            a.CUSTOMERID,
            a.ACCOUNT_OPENED_DATE,
            a.ACCOUNT_NUMBER,
            a.SORTCODE,
            b.CURRENT_BALANCE
        FROM 
            schema.CUSTOMER_ACCOUNTS as a 
        LEFT JOIN 
            schema.ACCOUNT_BALANCES as b 
        ON 
        a.ACCOUNT_NUMBER = b.ACCOUNT_NUMBER AND a.SORTCODE = b.SORTCODE 
    )
    ORDER BY CUSTOMERID, CURRENT_BALANCE DESC
;
DISCONNECT FROM TERADATA;
QUIT; 

/* ------------------------------------------------------------------------------------------ */

/* SAS to Impala */
PROC SQL;
    CONNECT TO IMPALA
    (USER="your_username" PW="your_password" DSN="your_dsn" DATABASE="your_database"); 
    CREATE TABLE 
        CUSTOMER_ACCOUNTS 
    AS SELECT 
        CUSTOMERID,
        INPUT(ACCOUNT_OPENED_DATE, YYMMDD10.) ACCT_OPENED FORMAT DATE9., /* changes number to date */
        ACCOUNT_NUMBER,
        SORTCODE,
        CURRENT_BALANCE

    FROM CONNECTION TO IMPALA 
    /* now everything inside this subquery, must be able to run on the remote DB connecting to */
    (
        SELECT 
            a.CUSTOMERID,
            a.ACCOUNT_OPENED_DATE,
            a.ACCOUNT_NUMBER,
            a.SORTCODE,
            b.CURRENT_BALANCE
        FROM 
            schema.CUSTOMER_ACCOUNTS as a 
        LEFT JOIN 
            schema.ACCOUNT_BALANCES as b 
        ON 
        a.ACCOUNT_NUMBER = b.ACCOUNT_NUMBER AND a.SORTCODE = b.SORTCODE 
    )
    ORDER BY CUSTOMERID, CURRENT_BALANCE DESC
;
DISCONNECT FROM IMPALA ;
QUIT; 

/* ------------------------------------------------------------------------------------------------ */

/* SAS to Hive */
PROC SQL;
    CONNECT TO HADOOP
    (
        URI="some_jdbc_string_for_Hive_connection",
        SERVER="your_server",
        SCHEMA="database_to_connect_to",
        HDFS_TEMPDIR="/tmp",
        PROPERTIES="hive.fetch.task.conversion=minimal;hive.fetch.task.conversion.threshold=-1" 
    );
    CREATE TABLE 
        CUSTOMER_ACCOUNTS 
    AS SELECT 
        CUSTOMERID,
        INPUT(ACCOUNT_OPENED_DATE, YYMMDD10.) ACCT_OPENED FORMAT DATE9., /* changes number to date */
        ACCOUNT_NUMBER,
        SORTCODE,
        CURRENT_BALANCE

    FROM CONNECTION TO HADOOP
    /* now everything inside this subquery, must be able to run on the remote DB connecting to */
    (
        SELECT 
            a.CUSTOMERID,
            a.ACCOUNT_OPENED_DATE,
            a.ACCOUNT_NUMBER,
            a.SORTCODE,
            b.CURRENT_BALANCE
        FROM 
            schema.CUSTOMER_ACCOUNTS as a 
        LEFT JOIN 
            schema.ACCOUNT_BALANCES as b 
        ON 
        a.ACCOUNT_NUMBER = b.ACCOUNT_NUMBER AND a.SORTCODE = b.SORTCODE 
    )
    ORDER BY CUSTOMERID, CURRENT_BALANCE DESC
;
DISCONNECT FROM HADOOP ;
QUIT; 
