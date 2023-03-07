# INDIA DEBIT 2
# INDIA CREDIT 1
# Australia DEBIT 1
# Australia CREDIT 1
# JAPAN DEBIT 1



c_broad = sc.broadcast([('IND', 'India'), ('AUS', 'Australia'), ('JPN', 'Japan')])

def c_name(record):
	code = record[-1]
	for key,value in c_broad.value:
		if key == code:
			record[-1] = value
	return record

trans = sc.textFile('/home/bigdata/trans.txt')

trans = trans.map(lambda x :x.split(','))


new_trans = trans.map(lambda record : c_name(record))

 new_trans.map(lambda x:((x[-1],x[1]),1)).reduceByKey(lambda a,b: a+b).collect()