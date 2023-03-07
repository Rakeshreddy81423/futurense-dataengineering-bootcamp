
# ===== a) Load Bank Marketing Dataset and create RDD ======

# Load the data from the csv file
bank = sc.textFile('/home/bigdata/bankmarketdata.csv/')

# Remove the header
data = bank.collect()

bank = sc.parallelize(data[1:])

#split the data based on the seperator ;
bank = bank.map(lambda row :   row.split(";"))

# ======== b) Give marketing success rate. (No. of people subscribed / total no. of entries) =============
# succcess rate is percentage of yes in column 'y' in all records
yes_count  = bank.filter(lambda row : row[-1] == '"yes"').count()

total_records = bank.count()


success_rate = yes_count / total_records * 100

# Output 
# 11.698480458295547


# ======= c) Give marketing failure rate ==========

no_count = bank.filter(lambda row: row[-1]=='"no"').count()


failure_rate = no_count / total_records * 100

# Output
# 88.30151954170445

'''
d) Maximum, Mean, and Minimum age of the average targeted 
customer
'''

min_age = bank.map(lambda row : int(row[0])).min() # 18

max_age = bank.map(lambda row : int(row[0])).max() # 95

avg_age =  round(bank.map(lambda row : int(row[0])).mean(),2)  # 40.94

''' 
e) Check the quality of customers by checking the 
average balance, median balance of customers
'''

avg_balance = round( bank.map(lambda row: int(row[5])).mean(),2)
# output : 1362.27

median_balance = bank.map(lambda row : float(row[5])).\
				 sortBy(lambda val :val,False).\
				 collect()[total_records // 2]
# output : 448.0


'''
f) Check if age matters in marketing subscription for deposit
g) Show AgeGroup [Teenagers, Youngsters, MiddleAgers, Seniors] wise Subscription Count.

'''

def find_group(age):
	grp = ""
	if age <=20:
		grp = "Teenagers"
	elif 20 < age <=40 :
		grp = "Youngsters"
	elif 40 < age <=60:
		grp = "MiddleAgers"
	else:
		grp = "Seniors"

	return grp 



 age_grp = bank.filter(lambda row: row[-1] == '"yes"').\
 				map(lambda row : (find_group(int(row[0])),1))


 age_grp.reduceByKey(lambda x,y : x+y).collect()

#Output:  [('Seniors', 502), ('Yongsters', 2924), ('Teenagers', 33), ('MiddleAgers', 1830)]


'''
h) Check if marital status mattered for subscription to deposit.
'''


'''
i) Check if age and marital status together mattered for subscription to deposit scheme
'''
