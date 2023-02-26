# rdd program to find the max and min temperatures
 # ---------------------------------------------------
# launch pyspark
# re librabry used to work with regular expressions
import re

# read the weather_data
rdd1 = sc.textFile("/home/bigdata/weather_data.txt")

# replace spaces and seperate values with ','
rdd2 = rdd1.map(lambda x: re.sub(r'\s+',',',x))

# daily_max is the fifth column convert it into float and find max 

max_temp = rdd2.map(lambda row : float(row.split(',')[5])).max()

# daily_min  is the sixth column convert it into float and find min

min_temp = rdd2.map(lambda row : float(row.split(',')[6])).min()