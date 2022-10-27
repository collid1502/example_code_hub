/* Create a dataset containing UK bank holidays between two dates */

data uk_bank_holidays (drop= start finish) ;
    format 
    year start finish 4. 
    EasterSunday GoodFriday EasterMonday ChristmasDay BoxingDay
    NewYearsDay MayBankHol SpringBankHol SummerBankHol Date9. ;

    start = year(today()) ;  /* find 4 digit year from today's date */ 
    finish = sum(start, 100) ; /* add 100 years to the value */
    
    do year = start to finish by 1;
    EasterSunday = holiday('EASTER', year) ;
    GoodFriday = intnx('DAY', EasterSunday, -2);
    EasterMonday = intnx('DAY', EasterSunday, 1);
    ChristmasDay = input(cats("25DEC", put(year, 4.)), DATE9.);
    BoxingDay = input(cats("26DEC", put(year, 4.)), DATE9.);
    NewYearsDay = input(cats("01JAN", put(year, 4.)), DATE9.);
    MayBankHol = nwkdom(1, 2, 5, year); /* finds 1st Monday (day=2) of May (month=5) for each year */
    SpringBankHol = nwkdom(5, 2, 5, year); /* finds LAST Monday (day=2) of May (month=5) for each year */
    SummerBankHol = nwkdom(5, 2, 8, year); /* finds LAST Monday (day=2) of August (month=8) for each year */
    
    output;
    end;
run;

proc transpose data=uk_bank_holidays out=uk_bank_holidays_2;
    by year;
    var _numeric_;
run;

data uk_bank_holiday_3 (keep= year holiday date day_of_week );
set uk_bank_holiday_2 (where=(_NAME_ not in ('year', 'EasterSunday')));

rename _NAME_ = Holiday;
format date Date9.;
Date=col1;
format day_of_week $10.;
    if weekday(date) = 1 then day_of_week='Sunday';
else if weekday(date) = 2 then day_of_week='Monday';
else if weekday(date) = 3 then day_of_week='Tuesday';
else if weekday(date) = 4 then day_of_week='Wednesday';
else if weekday(date) = 5 then day_of_week='Thursdau';
else if weekday(date) = 6 then day_of_week='Friday';
else if weekday(date) = 7 then day_of_week='Saturday';
run;

proc sort data=uk_bank_holidas_3;
    by date;
run;
