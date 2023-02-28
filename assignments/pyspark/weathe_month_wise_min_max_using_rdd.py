# read the data
weather_rdd = sc.textFile('/home/bigdata/weather_data.txt')


# months dictionary
 months = {'01':'Jan','02':'Feb','03':'Mar','04':'Apr','05':'May','06':'Jun',
...        '07':'Jul','08':'Aug','09':'Sep','10':'Oct','11':'Nov','12':'Dec'}

def month_name(row):
    month_num = row[2][4:6]
    row[2] = months[month_num]
    return row


# split the data by ','

weather_rdd = weather_rdd.map(lambda row : row.split())

# find the months_name
weather_rdd = weather_rdd.map(lambda row : month_name(row))

#make key,value pairs based on month for max temperatures
max_rdd = weather_rdd.map(lambda row:(row[1],float(row[5])))

#reduceByKey(max) finds and returns the month wise max 
month_wise_max_rdd = max_rdd.reduceByKey(max)

# print the list of month wise max as (month,max_temp) tuples
month_wise_max_rdd.take(10)

# output [('May', 31.1), ('Jan', 26.5), ('Feb', 26.6), ('Mar', 29.1), ('Apr', 30.8), ('Jun', 33.6), ('Jul', 36.0)]

# create key,value pairs like (month, min_temp)
min_rdd = weather_rdd.map(lambda row : (row[1],float(row[6])))

#reduceByKey(min) finds and returns the month wise min 
month_wise_min_rdd = min_rdd.reduceByKey(min)

# print the list of month wise min as (month,min_temp) tuples
month_wise_min_rdd.take(10)

#output [('May', 14.3), ('Jan', -7.9), ('Feb', -3.5), ('Mar', -3.2), ('Apr', 8.0), ('Jun', 0.0), ('Jul', 19.8)]




