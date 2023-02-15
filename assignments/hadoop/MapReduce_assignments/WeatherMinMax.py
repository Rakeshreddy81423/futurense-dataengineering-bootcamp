from mrjob.job import MRJob

class MinTemperature(MRJob):

        """ The below mapper() function defines the mapper for MapReduce and takes
        key value argument and generates the output in tuple format .
        The mapper below is splitting the line and generating a word with its own
        count i.e. 1 """
        def mapper(self, _, line):

                """
                From the dataset get the T_DAILY_MIN value. Convert it into float
                Since Min is a single value make key as same for all the data
                """
                yield("Min_temp",float(tuple(line.split())[6]))
                yield("Max_temp",float(tuple(line.split())[5]))


                        
        """ The below reducer() is aggregating the result according to their key and
        producing the output in a key-value format with its min  and max value"""
        def reducer(self, word,temperature):
                if word == 'Min_temp':
                    yield(word,min(temperature))
                else:
                    yield(word,max(temperature))

"""the below 2 lines are ensuring the execution of mrjob, the program will not
execute without them"""
if __name__ == '__main__':
        MinTemperature.run()
