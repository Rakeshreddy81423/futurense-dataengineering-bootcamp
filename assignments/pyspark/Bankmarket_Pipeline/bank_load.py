
import pyspark

from pyspark.sql import SparkSession

spark = SparkSession.builder.master("local").appName('bankdataLoadApp').getOrCreate()


HDFS_PATH ='/home/bigdata/bankmarketdata.csv'

bank_df =  spark.read.csv(path=HDFS_PATH,header=True,sep=';',inferSchema=True)


bank_df.write.parquet('/home/bigdata/bank_parquet/')