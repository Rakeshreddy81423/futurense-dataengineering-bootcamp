

'''
Spark dont have packages internally to handle AVRO files. So we need to pass those packages explicitly in spark-submit


master -local
************
Running spark in local mode
spark-submit --master local --packages org.apache.spark:spark-avro_2.12:3.3.2 Assignment_3.py

master - <master-ip>
*******************
Running spark in cluster mode.
1.) First lauch master and slave nodes
		start-master.sh
		start-slave.sh
2.) Find the master IP (You can find master IP at localhost:8080) and mention it in the spark-submit
		spark-submit --master spark://Rakesh.localdomain:7077 --packages org.apache.spark:spark-avro_2.12:3.3.2 Assignment_3.py


Scheduling
**************
Scheduling can be done using crontab
1.) start the cron serice
		sudo service cron start
2.) Check and confirm whether cron is running
		sudo service cron status
3.) Open crontab and mention the schedule
		crontab -e
	* It will open a file and mention the schedule.
		1 * * * * /path/to/file.py
	* The above line of code is to execute .py file every minute


'''
import pyspark

from pyspark.sql import SparkSession
from pyspark.sql.functions import *

spark = SparkSession.builder.appName("assignment3").getOrCreate()

# a) Load Bank Marketing Campaign Data from csv file
bank_df = spark.read.csv(path='/home/bigdata/bankmarketdata.csv',header=True,sep=';',inferSchema=True)

# b) Get AgeGroup wise SubscriptionCount
age_grp_df = bank_df.filter(col('y') == 'yes')\
					.withColumn('AgeGroup',when(col('age') <= 20 , 'Teenagers')\
								.when((col('age') >=21) & (col('age') <= 40) , 'Youngsters')\
								.when((col('age') >=41) & (col('age') <= 60) , 'MiddleAgers')\
								.otherwise('Seniors')\
								)

subscriptions = age_grp_df.groupBy('AgeGroup').agg(count('y').alias('SubscriptionCount'))

# c) Write the output in parquet file format

subscriptions.write.mode('overwrite').parquet('/home/bigdata/assignment3_out/parquet_out')

# d) Load the data from parquet file written above
parquet_bank_df = spark.read.parquet('/home/bigdata/assignment3_out/parquet_out')

# e) Show the data
parquet_bank_df.show()

'''
+-----------+-----------------+
|   AgeGroup|SubscriptionCount|
+-----------+-----------------+
| Youngsters|             2924|
|    Seniors|              502|
|  Teenagers|               33|
|MiddleAgers|             1830|
+-----------+-----------------+
'''


# f) Filter AgeGroup with SubcriptionCount > 2000 and write into Avro file format
subscriptions_filter = parquet_bank_df.filter(col('SubscriptionCount') > 2000)

subscriptions_filter.write.mode('overwrite').format("avro").save('/home/bigdata/assignment3_out/avro_out')

# g) Load the data from avro file written above
avro_df = spark.read.format('avro').load('/home/bigdata/assignment3_out/avro_out')

# h) Show the data
avro_df.show()


'''
+----------+-----------------+
|  AgeGroup|SubscriptionCount|
+----------+-----------------+
|Youngsters|             2924|
+----------+-----------------+
'''
