# a) Load Bank Marketing Campaign Data csv file from local to HDFS file system under '/user/training/bankmarketing/raw'

# sh file

hadoop fs -mkdir '/user/training/bankmarketing/'

hadoop fs -mkdir '/user/training/bankmarketing/raw/'

hadoop fs -put '/home/bigdata/bankmarketdata.csv' '/user/training/bankmarketing/raw'



# Spark_application
spark-submit --packages org.apache.spark:spark-avro_2.12:3.3.2

spark-submit \
--packages org.apache.spark:spark-avro_2.12:3.3.2 \
--jars "/home/bigdata/mysql-connector-j-8.0.32/mysql-connector-j-8.0.32.jar" bank_export.py



--jars "/home/bigdata/mysql-connector-j-8.0.32/mysql-connector-j-8.0.32.jar" bank_marketing-transformation.py