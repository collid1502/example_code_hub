/*
This code is designed to take any SAS dataset, convert all the columns to relevant number or string
data types, build an external table on Hive for all the columns in your data, and a given database 
and HDFS path, then insert data from SAS dataset into the remote table on Hive 
*/

/* changes required in below section per use case */
%let status = 0 ; /* used to indicate if you are creating new table or replacing existing */
                  /* use 0 for new, 1 for replace. Nothing else will work. */

%let dsn = my_data_set_name ; /* specify name of SAS dataset to load to Hive */
%let mylib = work ;           /* specify name of SAS library your dataset sits in */

%let hdp_sch = my_hadoop_db ; /* The DB name for where your external table will be created */
%let hdfspath = '/some/dummy/hdfs/path/my_table' ; /* HDFS location for the data of the external table */

/* ----------------------------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------------------------------------- */
/* NO FURTHER CHANGES REQUIRED BELOW */
/* ----------------------------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------------------------------------- */

/* stage 1 - collect details on data types from dataset to be loaded */
proc contents data=&mylib..&dsn. NOPRINT out=work.dsn_contents ;
run; quit;

data dsn_contents_2 (keep= varnum format_cat name type length format formatl formatd);
retain format_cat;
set work.dsn_contents.
format format_cat $10.;
format_cat = fmtinfo(format,'CAT');
run;
proc sort data=dsn_contents_2;
    by varnum;
run; 

/* clear first dsn contents */
proc datasets lib=work nolist nodetails;
    delete dsn_contents;
run; quit;

/* stage 2 - now check if any date / datetime variables exist within dataset. If so 
these will need to be uniformally converted to string/character before loading to Hadoop */
proc sql noprint;
    select coalesce(count(*),0) into: no_datevars
    from 
        (select distinct name 
            from work.dsn_contents_2 (where=(trim(format_cat)='date'))
        );
    
    select coalesce(count(*),0) into: no_datetvars
    from
        (select distinct name
            from work.dsn_contents_2 (where=(trim(format_cat)='datetime'))
        );
quit;
%put date variables = &no_datevars. 
%put datetime variables = &no_datetvars. 

/* stage 3 - create a temp version fo the dataset, so 
that modifications can be made to it before loading if required */
%if %sysfunc(exist(&mylib..temp_dsn1)) %then
%do;
    proc datasets lib=&my_lib. nolist nodetails;
        delete temp_dsn1;
    run; quit;
%end 

/* create temp dataset */
proc datasets lib=&mylib. nolist nodetails;
    append data=&dsn. base=temp_dsn1;
run; quit;

/* the following code establishes a value for a 'method' variable.
 The value of this variable determines future action to be taken by the code */
data _NULL_;
marki = &no_datevars. ;
markii = &no_datetvars.;
if marki = 0 and markii = 0 then
do;
    call symput('METHOD',0);
end;
else if marki > 0 and markii = 0 then
do;
    call symput('METHOD', 1);
end;
else if marki = 0 and markii > 0 then
do;
    call symput('METHOD', 2);
end;
else if marki > 0 and markii > 0 then
do;
    call symput('METHOD', 3);
end;
run;
%put &method.;

/* now create a macro that takes the 'method' value as input and 
determines the action required for changing the datatypes of variables
to remove dates & datetimes - reformatting to string/chars 
*/
%macro setmthd(mthd);
    %if &mthd. = 0 %then
    %do;
        %put no modification required ;
    %end;
    %else %if &mthd. = 1 %then
    %do;
        /* dates first */
        proc sql noprint;
            select trim(name) into: date_variables separated by ' '
            from (select distinct
                    name
                        from work.dsn_contents_2 (where=(trim(format_cat) in ('date')))
                );
        ; quit;
        %put &date_variables. ;

        /* modify dataset to re-format variables to one consistent format */
        proc datasets lib=work nodetails nolist;
            modify temp_dsn1;
            format &date_variables. YYMMDD.;
        run; quit;

        /* now turn them into character strings 
        we do this by creating text, placing into a macro, then running that macro 
        inside a datastep to create new variables, before dropping old ones */
        %macro one(varname);
            data temp_dsn1;
            set work.temp_dsn1;
            format &varname._n $50. ;
            if &varname. = . then 
            do;
                &varname._n = '';
            end;
            else do;
                &varname._n = trim(put(&varname., YYMMDD10.));
            end;
            drop &varname.;
            rename &varname._n = &varname. ;
            run;
        %mend one;

        %macro two(varlist);
            %local i;
            %do i = 1 %to %sysfunc(countw(&varlist.));
                %one(%scan(&varlist., &i.));
            %end;
        %mend two;
        %two(&date_variables.);
    %end;
    %else %if &mthd. = 2 %then
    %do;
        /* datetimes next */
        proc sql noprint;
            select trim(name) into: datetime_variables separated by ' '
            from (select distinct 
                    name, varnum
                        from work.dsn_contents_2 (where=(trim(format_cat) in ('datetime')))
                ) order by varnum;
        ; quit;
        %put &datetime_variables. ;

        /* modifying dataset to reformat variables to one consistent format */
        proc datasets lib=work nodetails nolist;
            modify temp_dsn1;
            format &datetime_variables. DateTime. ;
        run; quit;

        %macro onea(varname);
            data temp_dsn1;
            set work.temp_dsn1;
            format &varname._n $50.;
            if &varname. = . then 
            do;
                &varname._n = '';
            end;
            else do;
                &varname._n = trim(put(&varname., DATETIME.));
            end;
            drop &varname.;
            rename &varname._n = &varname. ;
            run;
        %mend onea;

        %macro twoa(varlist);
            %local i;
            %do i = 1 %to %sysfunc(countw(&varlist.));
                %onea(%scan(&varlist., &i.));
            %end;
        %mend twoa;
        %twoa(&datetime_variables.);
    %end;
    %else %if &mthd. = 3 %then
    %do;
        /* dates first */
        proc sql noprint;
            select trim(name) into: date_variables separated by ' '
            from (select distinct
                    name 
                        from work.dsn_contents_2 (where=(trim(format_cat) in ('date')))
                );
        ; quit;
        %put &date_variables.;
        
        /* datetimes next */
        proc sql noprint;
            select trim(name) into: datetime_variables separated by ' '
            from (select distinct 
                    name, varnum
                        from work.dsn_contents_2 (where=(trim(format_cat) in ('datetime')))
                ) order by varnum;
        ; quit;
        %put &datetime_variables. ;
        
        /* modify dataset to re-format variables to one consistent format */
        proc datasets lib=work nodetails nolist;
            modify temp_dsn1;
            format &date_variables. YYMMDD. ;
            format &datetime_variables. DateTime.;
        run; quit;

        /* now turn them to character strings 
        we do this by creating text, placing them into a macro, then running that 
        macro inside a datastep to create new variables, before dropping the old ones */
        %macro one(varname);
            data temp_dsn1;
            set work.temp_dsn1;
            format &varname._n $50. ;
            if &varname. = . then 
            do;
                &varname._n = '' ;
            end;
            else do;
                &varname._n = trim(put(&varname., YYMMDD10.));
            end;
            drop &varname. ;
            rename &varname._n = &varname. ;
            run;
        %mend one;

        %macro two(varlist);
            %local i ;
            %do i = 1 %to %sysfunc(countw(&varlist.));
                %one(%scan(&varlist., &i.));
            %end;
        %mend two;
        %two(&date_variables.);

        %macro onea(varname);
            data temp_dsn1;
            set work.temp_dsn1;
            format &varname._n $50. ;
            if &varname. = . then
            do;
                &varname._n = '';
            end;
            else do;
                &varname._n = trim(put(&varname., datetime.));
            end;
            drop &varname.;
            rename &varname._n = &varname. ;
            run;
        %mend onea;

        %macro twoa(varlist);
            %local i;
            %do i = 1 %to %sysfunc(countw(&varlist.));
                %onea(%scan(&varlist., &i.));
            %end;
        %mend twoa;
        %twoa(&dateime_variables.);
    %end;
%mend setmthd;
%setmthd(&method.);

/* stage 4 - now create an external table with the passed HDFS location and hadoop db 
            that we will insert data into */
/* ensure any number variables are formatted */
proc datasets lib=&mylib. nolist nodetails;
    modify temp_dsn1 ;
    format _NUMERIC_ best20.4 ;
run; quit;

proc contents
    data=work.temp_dsn1 noprint out=work.new_dsn_contents ;
run; quit;

data new_dsn_contents_2 (keep= varnum format_cat name type length format formatl formatd);
retain format_cat ;
set work.new_dsn_contents ;
format format_cat $10.;
format_cat = fmtinfo(format, 'CAT');
run;
proc sort data=new_dsn_contents_2;
    by varnum;
run; quit;

/* now build a template into a macro for the external table creation */
data work.template_setup;
format key $200.;
retain key;
set work.new_dsn_contents_2;
if lowcase(trim(format_cat)) = 'num' then
do;
    if formatl > 0 then
    do;
        key = cat(trim(name), " ", "DECIMAL(", formatl, ",", formatd, ")");
    end;
    else do;
        key = cat(trim(name), " ", "DECIMAL(20,2)");
    end;
end;
else do;
    if formatl > 0 then
    do;
        key = cat(trim(name), " ", "VARCHAR(", formatl, ")");
    end;
    else if length > 0 then
    do;
        key = cat(trim(name), " ", "VARCHAR(", length, ")");
    end;
    else do;
        key = cat(trim(name), " ", "VARCHAR(300)");
    end;
end;
run;

/* now place the created "keys" into a macro list */
proc sql noprint;
    select trim(key) into: variable_list separated by ', '
    from (select distinct
            key, varnum
                from work.template_setup) order by varnum ;

/* then place the variable names to be inserted into the empty table */
    select trim(name) into: insert separated by ', '
    from (select distinct
            name, varnum
                from work.template_setup) order by varnum ;
quit;
%put &variable_list. ;
%put &insert. ;

/* stage 5 - check if table already exists on Hadoop, if it does, alter it from external to 
managed, and then perform drop. 
*/
%put status = &status. ;

%if &status. = 1 %then
%do;
    proc sql;
        connect to impala(user="user" pw="password" dsn="dsn_name" database=&hdp_sch.);
        execute(alter table &hdp_sch..&dsn. set tblproperties('EXTERNAL'='False')) by impala;
        execute(drop table if exists &hdp_sch..&dsn.) by impala;
        disconnect from impala;
    quit;

    /* create external table via impala */
    proc sql;
        connect to impala(user="user" pw="password" dsn="dsn_name" database=&hdp_sch.);
        execute(drop table if exists &hdp_sch..&dsn.) by impala;
        execute(
            create external table &hdp_sch..&dsn. 
            (&variable_list.)
            row format delimited 
            fields terminated by '\001' 
            lines terminated by '\n' 
            stored as textfile 
            location &hdfspath. 
            tblproperties ("skip.header.line.count"="0") 
        ) by impala;
        disconnect from impala;
    quit;
%end;
%else %do;
    /* create external table via impala */
    proc sql;
    connect to impala(user="user" pw="password" dsn="dsn_name" database=&hdp_sch.);
    execute(
        create external table &hdp_sch..&dsn. 
        (&variable_list.)
        row format delimited 
        fields terminated by '\001' 
        lines terminated by '\n' 
        stored as textfile 
        location &hdfspath. 
        tblproperties ("skip.header.line.count"="0") 
    ) by impala;
    disconnect from impala;
    quit;  
%end;

/* stage 6 - use Hive in Libname for bulkload and write data to Hadoop */
libname hdp_test
HADOOP uri="jdbc_for_hadoop_or_hive_connection"
server="your_server_address"
schema="&hdp_sch."
hdfs_tempdir=&hdfspath.
properties="hive.fetch.task.conversion=minimal;hive.fetch.task.conversion.threshold=-1" ;

proc sql;
    insert into hdp_test.&dsn.
    select 
        &insert.
    from work.temp_dsn1 ;
quit;

proc datasets lib=work nolist nodetails;
    delete temp_dsn1 dsn_contents_2 new_dsn_contents new_dsn_contents_2 template_setup ;
run; quit;

/* end */