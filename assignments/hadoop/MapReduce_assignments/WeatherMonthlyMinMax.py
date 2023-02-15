from mrjob.job import MRJob

class MonthlyMinMax(MRJob):

        """ The below mapper() function defines the mapper for MapReduce and takes
        key value argument and generates the output in tuple format .
        The mapper below is splitting the line and generating a word with its own
        count i.e. 1 """
        def mapper(self, _, line):
                """
                In dataset we have date as a second column.
                Extract month from the date and map it's name from the list. Then pass it as key.
                """
                month = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

                month_num = int(list(line.split())[1][4:6])
                
                idx = month_num - 1
                month_key = month[idx]
                
            
                yield(month_key,float(tuple(line.split())[5]))
                # yield(month_key,float(tuple(line.split())[5]))


                        
        """ The below reducer() is aggregating the result according to their key and
        producing the output in a key-value format with its min  and max value"""
        def reducer(self, word,temperature):
            yield(word,max(temperature))
            

"""the below 2 lines are ensuring the execution of mrjob, the program will not
execute without them"""
if _name_ == '_main_':
        MonthlyMinMax.run()