import pyspark
import subprocess

from pyspark.sql import SparkSession
from pyspark.sql.functions import *

from datetime import datetime

spark = SparkSession.builder.master("local").appName("bankTransformationApp").getOrCreate()

date = datetime.now().strftime('%Y-%m-%d')

subprocess.run(f"hadoop fs -mkdir /user/training/bankmarketing/validated/{date}".split())

try:
    validated_df = spark.read.parquet('hdfs://localhost:9000/user/training/bankmarketing/validated/*.parquet')


    age_group_df = validated_df.filter(col('y') == 'yes').select('age').withColumn('Age_group', when(col('age') <= 20 ,'Teenagers')\
                                                                .when((col('age') > 20) & (col('age') <= 40) , 'Youngsters')\
                                                                .when((col('age') > 40) & (col('age') <= 60) , 'MiddleAgers')\
                                                                .otherwise('Seniors')\
                                                                ).groupBy('Age_group').agg(count('age').alias('SubscriptionCount'))


    subscription_count_filter_df = age_group_df.filter(col('SubscriptionCount') > 2000)

    subscription_count_filter_df.write.format("avro").save("hdfs://localhost:9000/user/training/bankmarketing/processed")

    age_group_df.write.mode('overwrite').csv(path= f"hdfs://localhost:9000/user/training/bankmarketing/validated/{date}/success",header=True)

except Exception as e:
    print(e)
    #if there is any error in the file reading create a error directory
    subprocess.run(f"hadoop fs -mkdir /user/training/bankmarketing/validated/{date}/error".split())

    # move the data to error folder
    subprocess.run(f"hadoop fs -mv /user/training/bankmarketing/validated/*.parquet /user/training/bankmarketing/validated/{date}/error".split())




