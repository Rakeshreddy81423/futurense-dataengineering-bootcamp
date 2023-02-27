# rdd program to find the max and min temperatures
# ---------------------------------------------------
# launch pyspark

# read the weather_data
rdd1 = sc.textFile("/home/bigdata/weather_data.txt")

# daily_max is the fifth column convert it into float and find max 

max_temp = rdd1.map(lambda row : float(row.split()[5])).max()

# daily_min  is the sixth column convert it into float and find min

min_temp = rdd1.map(lambda row : float(row.split()[6])).min()
