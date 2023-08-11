/*
Here's an example of how to transpose soem data from long to wide (aka Pivot data) 
*/ 

/* example data */
Data example_data ;
infile datalines dlm=',';
format account_number 8. sortcode 6. customer_name $100. customer_name_raw $200. ;
input account_number sortcode customer_name $ customer_name_raw $ ;
datalines;
87659001, 601001, Joe Bloggs LTD, J Bloggs Limited,
87659001, 601001, Joe Bloggs LTD, JBloggs Limited,
87659001, 601001, Joe Bloggs LTD, JBloggs LTD,
45670012, 601001, Made Up PLC, Made-Up PLC,
45670012, 601001, Made Up PLC, MadeUp P L C,
45670012, 601001, Made Up PLC, Made-Up P L C,
;
run;

/* sort data by account number, sortcode, customer name */
proc sort data=work.example_data;
by account_number sortcode customer_name ;
run; 

/* create an ID for each unique name in the customer_name_raw column */
Data example_data_2 ;
set work.example_data ;
by account_number sortcode customer_name ;

if first.customer_name then ID_no = 0;
ID_no + 1 ;
run; 


/* now, run the transpose of the data above */
proc transpose data=work.example_data_2 out=example_data_3 (drop= _name_) prefix=Cust_Name_ ;
    by account_number sortcode customer_name ;
    id ID_no ;
    var customer_name_raw ;
run; 

/* end */ 