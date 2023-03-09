# a) Load Bank Marketing Campaign Data csv file from local to HDFS file system under '/user/training/bankmarketing/raw'

# sh file

hadoop fs -mkdir '/user/training/bankmarketing/'

hadoop fs -mkdir '/user/training/bankmarketing/raw/'

hadoop fs -put '/home/bigdata/bankmarketdata.csv' '/user/training/bankmarketing/raw'

