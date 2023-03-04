import pyspark

from pyspark.sql import SparkSession

from pyspark.sql.functions import *
spark = SparkSession.builder.master("local")\
.appName("bankTransformationApp").getOrCreate()

cleaned_df = spark.read.parquet('/home/bigdata/bank_cleaned')


transformed_df = cleaned_df.filter(col('y') == 'yes').select('age').withColumn('Age_group', when(col('age') <= 20 ,'0-20')\
                                            .when((col('age') > 20) & (col('age') <= 30) , '21-30')\
                                             .when((col('age') > 30) & (col('age') <= 40) , '31-40')\
                                             .when((col('age') > 40) & (col('age') <= 50) , '41-50')\
                                             .when((col('age') > 50) & (col('age') <= 60) , '51-60')\
                                            .otherwise('61+')\
                                ).groupBy('Age_group').count()


transformed_df.write.mode('append') \
    .format("jdbc") \
    .option("url", "jdbc:mysql://localhost/pyspark_training") \
    .option("driver", "com.mysql.jdbc.Driver") \
    .option("dbtable", "bank_age_groups") \
    .option("user", "sqoop") \
    .option("password", "sqoop") \
    .save()