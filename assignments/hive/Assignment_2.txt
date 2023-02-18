Assignment -2
****************
# The weather_data is csv file
# create a weather folder in hdfs
	hadoop fs -mkdir /user/training/weather

# copy weather_data.csv to hdfs
	hadoop fs -put 'file:///home/cloudera/Desktop/hive/hive_futurense/dataset/weather/weather_data.csv' /user/training/weather/weather_input

# create external table
	create external table if not exists weather_ext
	(
		WBANNO  int,
		LST_DATE string,
		CRX_VN  float,
		LONGITUDE float,
		LATITUDE float,
		T_DAILY_MAX float,
		T_DAILY_MIN float,
		T_DAILY_MEAN float,
		T_DAILY_AVG float,
		P_DAILY_CALC float,
		SOLARAD_DAILY float,
		SUR_TEMP_DAILY_TYPE string,
		SUR_TEMP_DAILY_MAX float,
		SUR_TEMP_DAILY_MIN float,
		SUR_TEMP_DAILY_AVG float,
		RH_DAILY_MAX float,
		RH_DAILY_MIN float,
		RH_DAILY_AVG float,
		SOIL_MOISTURE_5_DAILY float,
		SOIL_MOISTURE_10_DAILY float,
		SOIL_MOISTURE_20_DAILY float,
		SOIL_MOISTURE_50_DAILY float,
		SOIL_MOISTURE_100_DAILY float,
		SOIL_TEMP_5_DAILY float,
		SOIL_TEMP_10_DAILY float,
		SOIL_TEMP_20_DAILY float,
		SOIL_TEMP_50_DAILY float,
		SOIL_TEMP_100_DAILY float
	)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ','
	stored as TEXTFILE
	location '/user/hive/weather/weather_output';


#load the data from hdfs
	 LOAD DATA INPATH '/user/training/weather/weather_input/weather_data.csv' overwrite into table weather_ext;

# Display Max, Min weather
	select max(t_daily_max) as max_temperature, min(t_daily_min) as min_temperature from weather_ext;
	
	output:
	*********
	+------------------+---------------------+--+
	| max_temperature  |   min_temperature   |
	+------------------+---------------------+--+
	| 36.0             | -7.900000095367432  |
	+------------------+---------------------+--+


# Display month wise Max and Min weather


select 
case 
when substring(LST_DATE,5,2) = '01' then 'Jan'
when substring(LST_DATE,5,2) = '02' then 'Feb'
when substring(LST_DATE,5,2) = '03' then 'Mar'
when substring(LST_DATE,5,2) = '04' then 'Apr'
when substring(LST_DATE,5,2) = '05' then  'May'
when substring(LST_DATE,5,2) = '06' then 'Jun'
when substring(LST_DATE,5,2) = '07' then 'Jul'
when substring(LST_DATE,5,2) = '08' then 'Aug'
when substring(LST_DATE,5,2) = '09' then 'Sep'
when substring(LST_DATE,5,2) = '10' then 'Oct'
when substring(LST_DATE,5,2) = '11' then 'Nov'
when substring(LST_DATE,5,2) = '12' then 'Dec'
end as Month,
max(t_daily_max) as max_temperature, min(t_daily_min) as min_temperature
from weather_ext group by substring(LST_DATE,5,2);


Output
*********
+--------+---------------------+---------------------+
| month  |   max_temperature   |   min_temperature   |
+--------+---------------------+---------------------+
| Jan    | 26.5                | -7.900000095367432  |
| Feb    | 26.600000381469727  | -3.5                |
| Mar    | 29.100000381469727  | -3.200000047683716  |
| Apr    | 30.799999237060547  | 8.0                 |
| May    | 31.100000381469727  | 14.300000190734863  |
| Jun    | 33.599998474121094  | 0.0                 |
| Jul    | 36.0                | 19.799999237060547  |
+--------+---------------------+---------------------+

