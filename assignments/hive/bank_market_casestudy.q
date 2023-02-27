1. Load data and create a Hive table

# create an external table and load the data

create table if not exists bankmarket
(
age int,
job String,
martial String,
education String,
default String,
balance int,
housing String,
loan String,
contact String,
day int,
month String,
duration int,
campaign int,
pdays int,
previous int,
poutcome String,
y String
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ";",
   "quoteChar"     = '"',
   "escapeChar"    = "\\"
)  
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");


# load the data from local

load data inpath '/user/training/retail/retail_input/bankmarketdata.csv' overwrite into table bankmarket;


# csv serde by default considers all the colums as string. So using view we typecast required fields
CREATE VIEW bank_data_view AS 
  SELECT 
    cast(age as int),
    job,
    martial,
    education,
    default,
    cast(balance as double),
    housing,
    loan,
    cast(contact as int),
    day,
    cast(month as int),
    cast(duration as int),
    cast(campaign as int),
    cast(pdays as int),
    cast(previous as int),
    poutcome,
    y    
  FROM bankmarket;

2. Give marketing success rate. (No. of people subscribed / total no. of entries)

select (sum(if(y='yes',1,0))/count(*) )* 100 as success_rate from bankmarket; 

+---------------------+
|    success_rate     |
+---------------------+
| 11.698480458295547  |
+---------------------+ 



3.	Give marketing failure rate

select (1-(sum(if(y='yes',1,0))/count(*)))* 100 as failure_rate from bankmarket;
+--------------------+ 
|    failure_rate    |
+--------------------+
| 88.30151954    |
+-------------------+


4.	Maximum, Mean, and Minimum age of the average targeted customer

select max(age) max_age, min(age) min_age, round(avg(age),1) avg_age from bankmarket;

+----------+----------+----------+
| max_age  | min_age  | avg_age  |
+----------+----------+----------+
| 95       | 18       | 40.9     |
+----------+----------+----------+


5.	Check the quality of customers by checking the average balance, median balance of customers

	select avg(balance) avg_balance, percentile_approx(balance,0.5) median_balance from bank_data_view;


+---------------------+-----------------+
|     avg_balance     | median_balance  |
+---------------------+-----------------+
| 1362.2720576850766  | 447.84375       |
+---------------------+-----------------+


6.	Check if age matters in marketing subscription for deposit

  select age, count(age) as total_customers  from bank_data_view where y="yes" group by age order by age desc;



7.	Check if marital status mattered for subscription to deposit.
	select martial, count(martial) as total_count from bank_data_view where y="yes" group by martial order by total_count desc;


+-----------+--------------+
|  martial  | total_count  |
+-----------+--------------+
| married   | 2755         |
| single    | 1912         |
| divorced  | 622          |
+-----------+--------------+


8.	Check if age and marital status together mattered for subscription to deposit scheme

select age, martial, count(*) as total from bank_data_view where y="yes" group by age,martial order by age desc;