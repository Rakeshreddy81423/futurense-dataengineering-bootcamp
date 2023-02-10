/*
	OLAP                                 OLTP
------------------------------------------------------
Online Anlytical Processing            Online Transaction Processing
Date, Numeric, Date type               Historical data
 */
 
 use hr;
 select  max(salary) over() 'maxsal', min(salary) over() 'minsal', avg(salary) over() 'avgsal' ,first_name from employees;
 
-- cumulative sum
select first_name, salary,sum(salary) over(order by salary) 'runsal' from employees;

/* Ranking functions
--------------------
row_number()
rank()
dense_rank()
 */
 
 -- row number
 select first_name, salary, row_number() over() 'rank' from employees;
 
 
 select first_name, salary, row_number() over(order by salary) 'rownumber' from employees;
 
 -- rank()
 select first_name, salary,row_number() over(order by salary desc) 'rownum', rank() over(order by salary) 'rank' ,dense_rank() over(order by salary) 'dense_rank'
 from employees;
 
 -- rank : when there is a tie it leaves a gap
 -- dense_rank : there will not be any gap
 
 
 -- Comparing Functions
 -- LAG and LEAD
 /* Lag returns the data from next row
	lead returns the data from previous row
    
    FIRST_VALUE()
    nth_value()
    LAST_VALUE() -- range between and rows 
    
    
 */
 
 select first_name, salary, lag(salary) over() 'lagsal', lead(salary) over() from employees;
 
 select first_name, lag(hire_date,2) over() , lead(hire_date,2) over() from employees;
 
 select first_name, lead(commission_pct, 2) over(order by commission_pct) from employees;
 

 
 use practice;

-- select ename, hiredate, lag() over(order by hiredate) 'next_hire_date' from emp
-- where job = 'analyst';

-- first_value()
select ename, sal,first_value(sal) over(order by sal desc) '1st' from emp;

select ename,sal,hiredate,first_value(hiredate) over(order by hiredate desc) '1st' from emp;

-- nth_value
select ename,sal,nth_value(sal,5) over(order by sal desc) 'nth' from emp;

-- last_value

select ename, sal, last_value(sal) over(range between unbounded preceding and unbounded following) 'last_value' from emp;

-- partition by
select ename, sal, sum(sal) over(partition by deptno) 'totsal', deptno
from emp;

-- ntile()
select ntile(3) over (order by deptno) as tile, ename,deptno from emp;


-- CTE (Common Table Expressions)
/*
  select * from (select ename from emp) a => derived table. inline view
  

 */
   with cte as 
  (
	select * from emp
  )
  select ename from cte;
  
  -- employees who are getting more than avg sal
  with cte as 
  (
	select deptno,avg(sal) 'avgsal' from emp group by deptno
  )
  select e.ename,e.sal,e.deptno, cte.avgsal from emp e inner join
  cte on e.deptno = cte.deptno and e.sal > cte.avgsal;
  
  -- employee name and his manager name
  select e.ename, m.ename as manager_name from emp e 
  inner join emp m on e.mgr = m.empno;
  
 select ename, deptno, count(empno) over(partition by deptno) from emp;
 
 
 -- recursive cte
 with recursive cte_2
 as 
 (
	select 1 'n'
    union all
    select n+1 from cte_2 where cte_2.n <= 30
 )
 select * from cte_2;
 
-- write a cte to generate calender for current month
set @date1 = '2023-01-01';
with recursive cte_2 as
(
	
    select @date1 'jan_calender'
    union all
    select date_add(jan_calender,interval 1 day) from cte_2 where day(cte_2.jan_calender) <=31
)
select * from cte_2;

-- print the daynames of every year till date from your birthday

set @birth = '1998-07-08';
with recursive bday as
(
	select @birth as date1
    union all 
    select year(date1) + interval 1 year from bday where year(bday.date1) <= year(curdate())
)
select * from bday;

use practice;
select ename,hiredate,first_value(hiredate) over w '1st', last_value(hiredate) over w 'last',
nth_value(hiredate,5) over w '5th' from emp window w as (order by hiredate);


--
with dc as ( select deptno,count(*) cnt from emp group by deptno)
select e.ename "emp",e.deptno "edep",m.ename "manager",m.deptno "mdep", dc2.cnt "managercount" from emp e join emp m
on  e.mgr = m.empno join dc dc1 on
e.deptno = dc1.deptno join dc dc2 on m.deptno = dc2.deptno;


-- 
show variables like 'basedir';
show variables like 'datadir';
 
 
 -- Data Dictionary View
 select tablespace_name, file_name from information_schema.files limit 10;
 
 /*
	tablespaces -> datafiles -> extents -> datapages -> rows
 */
create table check_tab(c1 int);


select tablespace_name, file_name,total_extents from information_schema.files where tablespace_name like 'practice/che%';

create table check_extent as select * from emp;
select * from check_extent;
desc check_extent;

-- set auto increment to a column
alter table check_extent modify empno int auto_increment primary key;

truncate table check_extent;

insert into check_extent(ename,job,mgr,hiredate,sal,comm,deptno)
select ename,job,mgr,hiredate,sal,comm,deptno from emp;

insert into check_extent(ename,job,mgr,hiredate,sal,comm,deptno)
select ename,job,mgr,hiredate,sal,comm,deptno from check_extent where ename <> 'king';

select tablespace_name, file_name,total_extents from information_schema.files where tablespace_name like 'practice/check_extent%';
select count(empno) from check_extent;

select count(empno) from check_extent where job= 'clerk';

-- Optimisation 

-- partitioned tables

create table list_job (empno int, ename varchar(20), job varchar(20))
partition by list columns(job)
(
	partition p_clerk values in ('clerk'),
    partition p_sales values in ('salesman'),
    partition p_anal values in ('analyst'),
    partition p_man values in ('manager'),
    partition p_pres values in ('president')
);

insert into list_job select empno,ename,job from check_extent;


explain select * from emp;
explain select count(*) from list_job where job='clerk';
 
explain select * from emp where deptno = 10;
explain select * from dept where dname='sales';

-- explain select * from departments where location_id = 1700;
 
explain select ename,sal from emp where sal in (select min(sal) from emp);


explain select deptno from emp where job='clerk'
union
select deptno from emp where job='salesman';

explain select ename,dname from emp natural join dept;
 
 
 create table fruit
 (
	id int,
    name varchar(10),
    price int
 );
 
 insert into fruit values(103,'Guava',80),(101,'Mango',150),(105,'Apple',200);
 select * from fruit;
 
 explain format=tree select * from fruit where id = 101;
 
 explain format = tree select * from list_job where job='president';
 
 explain format = tree select * from check_extent where job='president';
 
 -- indexing
 
 show index from practice.emp;
 
 /*
 for primary key, foreign key, and unique the indexes are automatically created
 */
 
 select distinct table_name,column_name,index_name from information_schema.statistics where table_schema = 'practice'
 and table_name = 'emp';
 
 create index id_idx on fruit(id);
 
 /*
 table scan -> if there is no index on the table
 index scan -> scanning the index 
 index lookup -> scanning the index and the row from the table
 */
  explain format=tree select * from fruit where id = 101;
  
 explain format=tree select id from fruit where id = 101;
 
 use practice;
 
 explain format = tree select * from regions where region_id = 1;
 show indexes from practice.emp;
 
 explain select ename from emp where job ='clerk';
 
 explain format=tree select ename from emp where job='clerk';
 
 /*
 optimisation is a trail and error.
 */
 
 explain select * from dept where dname='sales';
 
 explain format=tree select * from dept where dname='sales';
 
explain format = tree select * from emp where deptno = 20 and job='clerk';

/*
if table scan happens we can go for the below options
forcing index
use index
force index
ignore index 
*/

show indexes from emp;

show create table emp;

-- make index invisible
alter table emp alter index `FK_DEPTNO` invisible;

-- using below query we can see the indexes which are visible 
select index_name, is_visible from information_schema.statistics where table_schema = 'practice' and table_name = 'emp';

-- now run the same query. the cost will vary
explain format = tree select * from emp where deptno = 20 and job='clerk';

-- make index visible
alter table emp alter index `FK_DEPTNO` visible;

-- 
show indexes from check_extent;
explain format = tree select * from check_extent where deptno = 20 and job='clerk';

create index combine_idx1 on emp (deptno,job); 

explain format = tree select * from emp where deptno = 20 and job = 'clerk';

show indexes from fruit;

desc fruit;

explain format=tree select * from fruit where id = 101;

alter table fruit add constraint fruit primary key(id);

explain format=tree select * from fruit where id = 101;

show create table fruit;


-- range partitioning

create table range_part(empno int , ename varchar(20), sal int)
partition by range(sal)
(
	partition p_1000 values less than (1000),
    partition p_2000 values less than (2000),
    partition p_3000 values less than (3000),
    partition p_4000 values less than (4000),
    partition p_5000 values less than (5000),
    partition p_6000 values less than (6000)
);
insert into range_part select empno,ename,sal from check_extent;

explain select * from range_part where sal = 3000;


create table range_part_year(empno int , ename varchar(20), sal int,hiredate date)
partition by range(year(hiredate))
(
	partition y_1980 values less than (1980),
    partition y_1981 values less than (1981),
    partition y_1982 values less than (1982),
    partition y_1987 values less than (1987),
    partition y_2000 values less than (2000)
);




insert into range_part_year select empno,ename,sal , hiredate from check_extent;

explain select * from range_part_year where hiredate between date_format('1981-00-00',"%Y-%m-%d") and  date_format('1984-00-00',"%Y-%m-%d");

select partition_name,partition_ordinal_position,table_rows from information_schema.partitions where table_name='range_part_year';


select * from range_part_year partition(y_1981);


 
  -- hash partition 
create table hash_emp
(empno int primary key, ename varchar(20), sal float(11,2)) partition by hash(empno) partitions 4;

insert into hash_emp select empno, ename, sal from check_extent;

explain select * from hash_emp where empno = 14527;



-- temporary tables
-- will only available for the current session
-- they are not stored as a table in the db
create temporary table temp_1(sal float);
insert into temp_1 select sal from emp;

select * from temp_1;

-- CURSORS

-- delimiter //
-- create procedure pro_cursor (pno int)
-- begin
-- declare v1 numeric(11,2);
-- declare v2 varchar(20);
-- declare curl cursor for select sal,ename from emp where deptno = pno;
-- open curl;
-- 	getcur : loop
-- 			fetch curl into v1,v2;
-- 	end getcur;
--     


use practice;
explain select * from (select max(sal) from emp) a;

show indexes from practice.emp;



explain select * from emp where deptno=20 and job='clerk';

desc emp;
    
show indexes from emp;

alter table emp alter index `combine_idx1` visible;
explain select * from emp where hiredate='1981-12-03';

explain select * from emp where comm is null;

explain select * from emp where comm is not null;

explain format=tree select * from emp where deptno=20;

explain format = tree select * from emp where empno = 7369;


select * from sys.schema_unused_indexes;


explain select * from emp where empno > 7839;
explain select * from emp where empno like '75%';

explain select * from emp  where sal between 2000 and 3000;

explain select empno from emp;

explain format=tree select min(sal) from emp;

create index `sal_idx` on emp (sal);

explain format= tree select min(sal),job from emp group by job;

explain format=tree select sum(sal),job from emp where job <> 'analayst' group by job;

explain format=tree select count(empno),deptno from emp group by deptno having deptno in (60,80);

create table student1
(
	student_id int primary key,
    student_name varchar(15),
    result char(1),
    constraint chk_result check (result in('P', 'F'))
    
);


-- a . copy the rows from emp1 table fro student_id, student_name
insert into student1 select employee_id,first_name,null from hr.employees;


-- update the result with 'P' for name containing 'S'. For others enter 'F'
update student1 set result = 
case
	when student_name like '%s%' then 'P'
    else 'F'
end;

-- c. display number of students along with each type of result
select result, count(*) as total from student1 group by result;

-- d. using explain plan find out the operation
explain format=tree  select result, count(*) as total from student1 group by result;

create index `result_idx` on student1(result);
explain format=tree  select result, count(*) as total from student1  where result in ('P','F') group by result;

alter table student1 alter index `result_idx` visible;

select * from student1;

explain format=tree
select sum(salary),job_id from hr.employees group by job_id
union
select sum(salary),null from hr.employees;


explain format=tree select sum(salary),job_id from hr.employees group by job_id with rollup;

-- joins optimization

create table reg1 as select * from hr.regions;

create table country1 as select * from hr.countries;

-- when there are no indexes the join will perform hashjoin on the tables
explain select region_name,country_name from reg1 natural join country1;

-- optimizer joins
-- 1.) hash join  => whenever there are no indexes on tables to be joined
--  2.) nested loops join

create index reg_idx  on country1(region_id);

alter table country1 drop index reg_idx;
explain format=tree select region_name,country_name from reg1 natural join country1;

alter table reg1 add primary key(region_id);
alter table country1 add primary key(country_id);

alter table country1 add constraint fk_reg foreign key(region_id) references reg1(region_id);

create index comp_idx on reg1(region_id,region_name);

explain format=tree select region_name,country_name from reg1 natural join country1;

-- see the explain plan for the query and if there is a table scan then create index on the columns metioned in where clause.




-- composite partition
/*
	* main partition should be list/range
    * subpartition hash
	* and operator
*/

use practice;

create table compo_range_hash(empno int, ename varchar(20), sal int, job varchar(20))
partition by range(sal)
subpartition by hash(empno)
subpartitions 2
(
	partition P_1K values less than (1000),
    partition P_2K values less than (2000),
    partition P_3K values less than (3000),
    partition P_4K values less than (4000),
    partition P_MAX values less than  maxvalue
);
    
insert into compo_range_hash select empno, ename, sal, job
from check_extent;

select partition_name, table_rows, subpartition_name from information_schema.partitions where table_name='compo_range_hash';


explain select * from emp where sal in (select min(sal) from emp) ;
explain format=tree select * from emp where sal in (select min(sal) from emp);

 -- subquery plan of execution
 
 
 show indexes from emp;
 
 explain format=tree select * from emp  force index (sal_idx) where sal = (select min(sal) from emp) ;
 
 -- correlated subquery
 -- in correlated subquery make use of exist operator
  explain format=tree select ename, sal, deptno from emp e where sal > (select avg(sal) from emp where deptno = e.deptno);
  
 explain format = tree select dname,deptno from dept where deptno not in (select deptno from emp);
 
explain format = tree select dname,deptno from dept where exists  (select deptno from emp);

show create table emp;
 
show engines;

show indexes from emp;

-- functional indexes

-- create index on hiredate
create index hiredate_idx on emp(hiredate);

 explain format=tree select * from emp where monthname(hiredate) = 'january';
 
 explain format=tree select * from emp where hiredate = '1981-01-01';
 
 -- add index on monthname()
 alter table emp add index((monthname(hiredate)));
explain format=tree select * from emp where monthname(hiredate) = 'january';


explain format = tree select * from emp where year(hiredate) = 1981;

alter table emp add index((year(hiredate)));

explain format = tree select * from emp where year(hiredate) = 1981;


-- hash index
-- hash indexes cannot be created in innodb, they are created in memory engine

create table testhash(
fname varchar(50) not null,
lname varchar(50) not null,
key using hash(fname)
) engine=memory;

insert into testhash select first_name,last_name from hr.employees where DEPARTMENT_ID in (60,90);

explain format=tree select * from testhash where fname='Alexander';

-- full text index
create table full_t as select first_name,last_name from hr.employees;
alter table full_t add fulltext(first_name,last_name);

explain format = tree select * from full_t where match(first_name,last_name) against ("Alexander%");



explain format=tree select  case
when sal > 3000 then "good salary" 
when sal = 3000 then "avg salary"
when sal < 3000 then "poor salary"
end as rating  from  emp where deptno = 30;

show indexes from emp;

explain format=tree select ename,sal,sal*1.5 as newsal from emp;

explain format=tree select * from emp where sal*1.5 > 3000;
explain format=tree select * from emp where sal> 3000/1.5;

-- profiling
select @@profiling;

set profiling=1;

select * from hr.regions;
select count(*) from check_extent;
select * from compo_range_hash where sal=3000;

show profile for query 2;

set @@profiling=0;


use new_hr;

with cte as
(
	select department_id, sum(salary)  as sum_sal
    from employees 
    group by department_id
)
select * from cte where sum_sal > (select avg(sum_sal) from cte);



