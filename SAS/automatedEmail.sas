/* script for sending emails from within a programme */

OPTIONS EMAILSYS=SMTP EMAILHOST=<insert your host here> EMAILPORT=<inset email port here> ;

filename myemail email _all_

from=("dummyUser@email.com") 

to=("User1@fake.com", "User2@fake.com") 

subject = "Enter your email subject here" 

data _NULL_ ;
file myemail ;

put "line 1"

/ "line 2"

/ "line 3" 
;
run;

filename myemail clear ; 
