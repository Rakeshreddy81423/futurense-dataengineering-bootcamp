import pyspark

from pyspark.sql import SparkSession

spark = SparkSession.builder.master("local").appName("bankCleaningApp").getOrCreate()

#file_path = '/home/bigdata/bank_parquet/'

bank_parquet_df = spark.read.parquet('/home/bigdata/bank_parquet')

new_df = bank_parquet_df.filter('not age is NULL')

new_df.write.parquet('/home/bigdata/bank_cleaned')