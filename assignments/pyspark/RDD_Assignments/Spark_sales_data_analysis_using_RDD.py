# load the sales data into hdfs from local
hadoop fs -put '/mnt/c/Users/rakes/OneDrive/Desktop/sales.csv' 'hdfs://localhost:9000/user/spark'

# Create RDD from the csv file
sales = sc.textFile('hdfs://localhost:9000/user/spark/sales.csv')

# take the first row 
header = sales.first()

# filter the first row from data
sales = sales.filter(lambda row : row != header)

#split the data based on ','
sales = sales.map(lambda row : row.split(','))

#cache the frequently used rdd. So that access will be more fast
sales.cache()


# 1.) Display the number of countries present in the data?
	sales.map(lambda row:row[1]).distinct().count() 

# 2.) Display the number of units sold in each region?
	sales.map(lambda row: (row[0],int(row[8]))).reduceByKey(lambda a,b : a+b).collect()

# 3.Display the 10 most recent sales?
	
	#Orderdate is in string format. Change it to datetime object so that we can sort them.

	q3_rdd = sales.map(lambda row: row[:5] + [datetime.strptime(row[5],'%m/%d/%Y')] + row[6:])
	
	#sortBy sorts the records based on row[5] i.e, datetime object. Here ascending=False return records in descending order
	#and convert the datetimeobject back to string format. Here -m -d removes the leading 0's in month and day.

	q3_rdd.sortBy(lambda row : row[5],ascending=False).map(lambda row : row[:5] + [row[5].strftime('%-m/%-d/%Y')] +row[6:]).take(10)
	



# 4.Display the products with atleast 2 occurences of 'a' ?
	products_rdd = sales.filter(lambda row: row[2].count('a') >=2)
	products_rdd.collect()

	

# 5.Display country in each region with highest units sold?
	#take the required columns
	country_sales = sales.map(lambda row : ((row[0] , row[1]),int(row[8])))

	#find region and country wise total unit solds
	c_reduced = country_sales.reduceByKey(lambda a,b :a+b)

	# key = Region , value = (country, total unit solds) and perform reduceBy region
	c_reduced.map(lambda x: (x[0][0],(x[0][1],x[1]))).reduceByKey(lambda a,b : max(a,b ,key=lambda x : x[1])).collect()
	
# 6.Display the unit price and unit cost of each item in ascending order. (Using spark)
	sales.map(lambda row : (row[2],row[9],row[10])).distinct().collect()
	
	
# 7.Display the number of sales yearwise?
	#extract year from the orderdate 
	year_sales = sales.map(lambda row : (row[5].split('/')[-1],int(row[8])))
	year_sales.reduceByKey(lambda a,b :a +b).collect()
	
	
# 8.Display the number of orders for each item?
	items_count = sales.map(lambda row : (row[2],int(row[8])))
	items_count.reduceByKey(lambda a,b : a + b).collect()


	

## Store the result of year_wise_sales into hdfs

# To get the result into one file first coalesce and then save it.
year_sales.reduceByKey(lambda a,b :a +b).coalesce(1).\
saveAsTextFile('hdfs://localhost:9000/user/training/spark/sales/year_wise_sales')
