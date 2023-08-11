/*
An example of how to create your own dataset from typed values.

This example is Bank of England Base rate history (recent) 
*/

Data BOE_base_rate_hst ;
infile datalines dlm=',' ;
format Date Date9. Base_Rate 7.3 Rate $10. ;
Input Date YYMMDD10. Base_Rate Rate $ ;
datalines;
2020-03-19, 0.10, BOE,
2020-03-11, 0.25, BOE,
2018-08-02, 0.75, BOE,
2017-11-02, 0.50, BOE,
;
run;

/* sort data by descending date */ 
proc sort data=work.BOE_base_rate_hst ;
by Rate descending Date ;
run;

/* now, use a lag function to collect the previous Rate's date (so we have an expiry date for each rate) 
Also, for the first rate that appears, set a default high of 1st Jan 9999, as that rate is still live! */

Data work.BOE_base_rate_hst ;
Set work.BOE_base_rate_hst ;
by Rate ;
format Expiry date9. ;
Expiry = lag1(Date) ;

if first.Rate then Expiry = "01JAN9999"d ;
run;

/* end of script */ 