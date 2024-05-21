-- WARNING - ensure the postgres server is running on Ubuntu first before trying to connect.
-- use :
/*
sudo service postgresql start

or

sudo service postgresql restart

and to stop: sudo service postgresql stop 
 */
-- ==============================================================================================================
-- create a new schema inside the "TestDatabase" on local postgres
create schema if not exists "customer_data" ;

-- create a master customer table
drop table if exists customer_data.master_customer ;

create table if not exists customer_data.master_customer
(
	customer_id integer primary key,
	first_name varchar(300),
	last_name varchar(300),
	rewards_member bool,
	email varchar(300),
	postcode varchar(12),
	profession varchar(100),
	dob date,
	customer_joined timestamp 
) ;

-- copy a local CSV file of data into this table 
copy customer_data.master_customer 
from '/home/collid/work/example_code_hub/Spark/exploring_PySpark/data/customerMasterExtract.csv'
delimiter ','
csv header ; -- header keyword tells postgres to ignore line 1 of file

-- test it with query 
select * from customer_data.master_customer limit 10 ; 

-- great, now build the transactions table 
drop table if exists customer_data.transactions ; 

create table if not exists customer_data.transactions
(
	customer_id integer,
	transaction_ts timestamp,
	product varchar(100),
	volume decimal(10,1),
	price decimal(10,2),
	transaction_amt decimal(10,2)
);

-- copy local CSV data into table 
copy customer_data.transactions 
from '/home/collid/work/example_code_hub/Spark/exploring_PySpark/data/dummy_txns.csv'
delimiter ','
csv header ; -- header keyword tells postgres to ignore line 1 of file


-- test it 
select * from customer_data.transactions limit 10 ; 

-- =============================================================================================
/*
 Example Queries using CTEs & JOINs etc 
 */

with reward_member_transactions as (
	select 
		t1.customer_id, t1.rewards_member,
		t2.transaction_ts, t2.product, t2.volume, t2.price, t2.transaction_amt 
	from 
		customer_data.master_customer as t1
	left join 
		customer_data.transactions as t2 
	on t1.customer_id = t2.customer_id 
	where t1.rewards_member is true 
)

select 
	count(*) as number_of_rewards_transactions
from reward_member_transactions 
;
