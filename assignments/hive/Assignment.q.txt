# create external table and skip the header

create external table if not exists ratings_ext
(
userId int,
movieId int,
rating float,
timestamp int
)
row format delimited
fields terminated by ','
lines terminated by '\n'
location '/user/hive/warehouse/ratings'
tblproperties("skip.header.line.count"="1");


# load the data from local into table
load data local inpath '/home/cloudera/Desktop/hive/hive_futurense/dataset/ratings.csv' overwrite into table ratings_ext


#find the each rating count
select rating, count(*) as total_count from ratings_ext group by ratings;


#output
---------------------------
+---------+--------------+--+
| rating  | total_count  |
+---------+--------------+--+
| 0.5     | 1370         |
| 1.0     | 2811         |
| 1.5     | 1791         |
| 2.0     | 7551         |
| 2.5     | 5550         |
| 3.0     | 20047        |
| 3.5     | 13136        |
| 4.0     | 26818        |
| 4.5     | 8551         |
| 5.0     | 13211        |
+---------+--------------+--+
