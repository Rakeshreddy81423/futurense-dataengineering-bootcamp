// Assignment -3
// **************** 

# There are two files customer.txt and transactions.txt
# Both are commaseperated


# create external table for customers

create external table if not exists customers_ext
(
cust_id int,
last_name string,
first_name string,
age int,
profession string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE

LOCATION '/user/training/retail/customers';

#load data from the local path

	load data local inpath '/home/cloudera/Desktop/hive/hive_futurense/dataset/retail/customers.txt' overwrite into table customers_ext;


#crete transactions table

create external table if not exists transactions_ext
(
trans_id int,
trans_date string,
cust_id	 int,
amount double,
category string,
desc string,
city string,
state string,
pymt_mode string
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE

location '/user/training/retail/transactions'



#load data from the local path

	load data local inpath '/home/cloudera/Desktop/hive/hive_futurense/dataset/retail/transactions.txt' overwrite into table transactions_ext;


/* Analysis
********** */
 
 /* 1.) No of transactions by customer */

	select cust_id, count(trans_id) as trans_count from transactions_ext group by cust_id;

/* Output
********* */
+----------+--------------+--+
| cust_id  | trans_count  |
+----------+--------------+--+
| 4000001  | 8            |
| 4000002  | 6            |
| 4000003  | 3            |
| 4000004  | 5            |
| 4000005  | 5            |
| 4000006  | 5            |
| 4000007  | 6            |
| 4000008  | 10           |
| 4000009  | 6            |
| 4000010  | 6            |
+----------+--------------+--+


/* 2) Total transaction amount by customer */

	select cust_id, sum(amount) as total_amount from transactions_ext group by cust_id;

/* Output
********* 
+----------+---------------------+--+
| cust_id  |    total_amount     |
+----------+---------------------+--+
| 4000001  | 651.05              |
| 4000002  | 706.97              |
| 4000003  | 527.5899999999999   |
| 4000004  | 337.06              |
| 4000005  | 325.15              |
| 4000006  | 539.38              |
| 4000007  | 699.5500000000001   |
| 4000008  | 859.42              |
| 4000009  | 457.83              |
| 4000010  | 447.09000000000003  |
+----------+---------------------+--+


3.) Get top 3 customers by transaction amount  */

	select cust_id, sum(amount) as total_amount from transactions_ext group by cust_id order by total_amount desc limit 3;
 
/* Output
********
+----------+--------------------+--+
| cust_id  |    total_amount    |
+----------+--------------------+--+
| 4000008  | 859.42             |
| 4000002  | 706.97             |
| 4000007  | 699.5500000000001  |
+----------+--------------------+--+ 

	
4.) 4) No of transactions by customer and mode of payment */

select cust_id, pymt_mode,count(trans_id) as trans_count from transactions_ext group by cust_id, pymt_mode;

/* Output:
*********
+----------+------------+--------------+--+
| cust_id  | pymt_mode  | trans_count  |
+----------+------------+--------------+--+
| 4000001  | cash       | 1            |
| 4000001  | credit     | 7            |
| 4000002  | cash       | 1            |
| 4000002  | credit     | 5            |
| 4000003  | credit     | 3            |
| 4000004  | cash       | 4            |
| 4000004  | credit     | 1            |
| 4000005  | cash       | 1            |
| 4000005  | credit     | 4            |
| 4000006  | credit     | 5            |
| 4000007  | credit     | 6            |
| 4000008  | credit     | 10           |
| 4000009  | credit     | 6            |
| 4000010  | credit     | 6            |
+----------+------------+--------------+--+  

5.) 5) Get top 3 cities which has more transactions */
	select city, count(trans_id) as trans_count from transactions_ext group by city order by trans_count desc limit 3;

Output:
*************
+-------------+--------------+--+
|    city     | trans_count  |
+-------------+--------------+--+
| Columbus    | 3            |
| Honolulu    | 3            |
| Hampton     | 2            |
+-------------+--------------+--+


6.) Get month wise highest transaction

select 
case 
when substring(trans_date,1,2) = '01' then 'Jan'
when substring(trans_date,1,2) = '02' then 'Feb'
when substring(trans_date,1,2) = '03' then 'Mar'
when substring(trans_date,1,2) = '04' then 'Apr'
when substring(trans_date,1,2) = '05' then  'May'
when substring(trans_date,1,2) = '06' then 'Jun'
when substring(trans_date,1,2) = '07' then 'Jul'
when substring(trans_date,1,2) = '08' then 'Aug'
when substring(trans_date,1,2) = '09' then 'Sep'
when substring(trans_date,1,2) = '10' then 'Oct'
when substring(trans_date,1,2) = '11' then 'Nov'
when substring(trans_date,1,2) = '12' then 'Dec'
end as Month, count(trans_id) as trans_count
from transactions_ext
group by substring(trans_date,1,2)
order by trans_count desc;



Output:
*********
+--------+--------------+--+
| month  | trans_count  |
+--------+--------------+--+
| Oct    | 10           |
| Jun    | 10           |
| May    | 8            |
| Feb    | 6            |
| Nov    | 5            |
| Dec    | 4            |
| Sep    | 4            |
| Apr    | 4            |
| Mar    | 3            |
| Aug    | 2            |
| Jul    | 2            |
| Jan    | 2            |
+--------+--------------+--+

7) Get sample transactions

select * from transactions_ext limit 10;
