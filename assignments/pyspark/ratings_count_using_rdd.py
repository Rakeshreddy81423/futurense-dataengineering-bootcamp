
# read the csv file
rating_rdd = sc.textFile('/home/bigdata/ratings.csv')

# store header into a variable
 header = rating_rdd.first()

 #remove header
 rating_rdd = rating_rdd.filter(lambda row: row!=header)

# create key, value pairs based on the rating
key_rdd = rating_rdd.map(lambda row : (row.split(',')[2],1))

# find the count of each rating
key_rdd.reduceByKey(lambda a,b: a+b).collect()


# output
'''
	[
		('5.0', 13211), ('2.0', 7551), ('1.0', 2811), ('0.5', 1370), 
		('1.5', 1791), ('4.0', 26818), ('3.0', 20047), ('4.5', 8551), ('3.5', 13136), ('2.5', 5550)
	]
'''
