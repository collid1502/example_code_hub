/* VSAM is a flat file format that can be found on IDM systems / mainframes for data storage */
/* This process would typically involve connecting to a Remote SAS server, maybe running SAS 
    on a mainframe for example. This code assumes that connection is performed via a 
    global macro called "connect_to_mainframe" 
*/

%connect_to_mainframe;

libname rwork slibref=work server=<server> ;

%syslput Gen = &Gen. ; /* picks up global &Gen set before */
%syslput Date = &Date. ; /* likewise with date */

rsubmit; /* remote submits code to the connection of remote mainframe server */
Data _NULL_ ;
call symput('Date2', put("&Date."d, yymmddn6.));
run;
%put Date = &Date. ; /* write `Date = ...` to log */
%put Date2 = &Date2. ;
%put Gen = &Gen. ;

/***********************************************************************/
/* create a dataset that has a High Level Qualifier for each brand */
rsubmit;
data InputFiles;
input HLQ $5. brand $4. ;
VCTRL = compress("'"||HLQ||".VCTRL'");
if brand = "" then delete;
datalines;
PRB1 BRAND1
PRB2 BRAND2
PRB3 BRAND3
PRB4 BRAND4
; run;
endrsubmit; /*closes out the block of code for remote submission */

/* Now, let's imagine we want to build a dataset, by reading many files, so we loop over 
    the file names created in the variable VCTRL (above dataset)
*/
rsubmit;
Data accountMast (keep=brand accMas) ;
set InputFiles (keep= brand VCTRL);
infile dummy filevar = VCTRL end=done;
    do while(not done);
        input @120 DSName $CHAR45. ;
        VACMAS = compress("'"||tranwrd(dsname, "vAccMas", "nAccMas")||".BKUP(&gen.)'");

        if scan(DSName,2,".")="vAccMas" 
        and scan(DSName,3,".") not in ("Y1", "Y2") then output;
    end;
run;
endrsubmit;

/* ----------------------------------- */
/* Now read in the files to a Data Set */
/* ----------------------------------- */
data vAccMas ;
set accountMast;
infile dummy filevar = VACMAS end=done;
do while(not done);
    input @1 customer_name $50.
          @10 customer_number pd5.
          @14 customer_code $CHAR3.
          @17 strtdate pd5.
    ;
    if strtdate <> 0 then customer_start_date = input(put(strtdate,8.), yymmdd8.);
    drop strtdate ;
    format customer_start_date date9. ;
    output;
end;
proc sort;
    by customer_number ;
run;
endrsubmit;

/* write data back from remote session to local SAS session */
rsubmit;
proc download data=vAccMas out=work.AccountsMaster ;
run;
endrsubmit;

signoff; /* exits remote session */