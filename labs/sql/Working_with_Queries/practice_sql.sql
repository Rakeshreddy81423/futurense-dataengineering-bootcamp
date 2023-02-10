
show columns from  dept;


select * from emp where job ='salesman';

select * from emp where sal > 2975;
select * from emp where job not like 'clerk';

select * from emp where deptno = 20 and job = 'clerk';

-- greater than 3000 not using >
select * from emp where not sal < 3000;

/* dont use like where = works */
select ename from emp where ename between 'james' and 'turner';


-- emp names with exactly 4 characters
update emp set job = 'hr_clerk' where job ='clerk';


use practice;

select hiredate,date_format(hiredate ,'%D') from emp;


-- find person joined on first thursday
select ename,hiredate,dayname(HIREDATE) from emp
where date_format(hiredate,'%d') between 1 and 7 and dayname(HIREDATE) = 'Thursday';

-- ename joined on 17th, tuesday december 1981
select ename,hiredate,dayname(HIREDATE)
from emp
where date_format(hiredate,'%d') = 17 and dayname(hiredate)='Tuesday';


-- extract()
select extract(year from hiredate) as 'Year', extract(month from hiredate) 'month',extract(day from hiredate) 'Day',
day(hiredate), ename from emp;


select datediff(curdate(),hiredate) 'diff' from emp;

select timestampdiff(month,hiredate,curdate()) 'diff' from emp;
select timestampdiff(year,hiredate,curdate()) 'diff' from emp;

-- how old are you
select timestampdiff(year,'1998-07-08',curdate()) 'years', timestampdiff(month,'1998-07-08',curdate()) % 12 'months',
day(curdate() - date_format('1998-07-08','%d')) 'days';

select day(curdate() - date_format('1998-07-08','%d'));


-- add and subtract 1 year to current date
select date_add(curdate(),interval '1' year) 'adding 1 year', date_sub(curdate(),interval '1' year) 'sub 1 year';

-- add and sub 1 month

select date_add(curdate(),interval '1' month) 'adding 1 month', date_sub(curdate(),interval '1' month) 'sub 1 month';

-- add and sub 1 day
select date_add(curdate(),interval '1' day) 'adding 1 day', date_sub(curdate(),interval '1' day) 'sub 1 day';

-- last day of the month

select hiredate, last_day(hiredate) from emp;


-- makedate
select makedate(2023,130);


-- control functions

/* if , case, nullif, ifnull */
-- if(a,b,c)  if a is true return b else c

select ename,sal,if(sal>3000,'good sal','low sal') 'comments' from emp;

-- case when
select ename,job,sal,
case
	when  job = 'clerk' then 1.5 * sal
    when job = 'salesman' then 2.0*sal
    when job = 'analyst' then 1.75 * sal
    else sal
end as 'new sal'
from emp;


set @dob = '2022-12-29';
select datediff(@dob,curdate()) 'diff',
case
	when datediff(@dob,curdate()) = 0 then repeat('happy bday',5)
    when datediff(@dob ,curdate()) <0 then repeat('belated bday',2)
    else repeat('advance bday',1)
end as 'wish';


-- null if (a,b) ==> if a=b then return null else the first value

select ename, length(sal) as 'sal_len',length(ename) as'name_len',nullif(length(sal),length(ename))
from emp
order by 4;

-- ifnull (a,b) => returns first non-null value and returns null when both are null

select ifnull(2,3),ifnull(null,4),ifnull(2,null),ifnull(null,null);
-- str_to_date()
select str_to_date('10/may/2022','%d/%M/%Y') as date_;


select str_to_date('10-05-2022','%d-%m-%Y') as date_;

-- set @@sql_mode='only_full_group_by';

-- set sql_mode ='';


-- aggregate functions
-- count,min,max,avg,sum

-- count(*) includes nulls , count(ename) excludes nulls

select count(hiredate),count(ename),count(sal),count(comm) from emp;

-- find how many clerks
select count(empno) from emp where job ='clerk';

-- count.min,max used for all datatypes

-- sum,avg used for numeric datatypes

select sum(sal),deptno from emp group by deptno;

-- find number of employees joined in each year
select year(hiredate) 'year', count(empno) from emp
group by year(hiredate) 
order by year(hiredate);

-- find the count of employees in each quarter of a year

select year(hiredate) year, quarter(hiredate) Quarter,count(empno) from emp
group by year(HIREDATE), quarter(hiredate)
order by year,quarter;


-- find out number of employees joined in each month and sort the data 

select year(hiredate) year,monthname(hiredate) month_name,count(empno) from emp
group by year(HIREDATE),monthname(hiredate)
order by date_format(hiredate,'%m');


select DEPTNO,count(empno) total,round(avg(sal)) avg_sal
from emp
group by deptno
having count(empno) > 5;


select job,max(sal) as max_sal
from emp
group by job
having max(sal) >= 3000;


select job,sum(sal), max(sal),min(sal),avg(sal)
from emp
where DEPTNO = 20
group by job
having avg(sal) >1000;

-- 29-12-2022
use practice;

select distinct job from emp where deptno in (10,20);

-- using union

select job from emp where deptno = 10
union
select job from emp where deptno = 20;


-- intersect
select job from emp where deptno = 10
intersect
select job from emp where deptno = 20;


select null job,sum(sal) total_sal from emp
union
select job,sum(sal)from emp group by job;

-- roll up
select sum(sal),job from emp
group by job with rollup;

-- roll up gives summary values only for the first column
select sum(sal),deptno,job from emp
group by job,deptno with rollup;


-- order by works only for the columns mentioned in the first select statement

select ename from emp
union
select dname from dept
order by ename;


-- joins
 -- find out the total salary for departments sales and accounting
select sum(sal) total_sal, dname from emp e inner join
dept d on e.deptno = d.deptno
and  dname in ('sales','accounting')
group by dname;


-- find out the 

select ename
from emp e inner join dept d
on e.deptno = d.deptno
where  d.loc ='chicago' and e.job='clerk';

select e.ename,d.dname
from emp e right outer join dept d
on e.deptno = d.deptno;


select e.ename,d.dname,s.grade
from emp e inner join dept d
on e.deptno = d.deptno
join salgrade s 
on e.sal between s.losal and s.hisal;


create database new_hr;

use new_hr;
show tables;


select r.region_name,c.country_name,l.city from regions r inner join countries c
on r.region_id = c.region_id
join locations l on l.country_id = c.country_id;

-- employees who are taking the same salary
select concat(first_name," ",last_name),salary from employees
where salary in (select salary from employees group by salary having count(employee_id) >1 );

select distinct concat(e.first_name,' ',e.last_name),e.salary,
concat(m.first_name,' ',m.last_name) employee2  from employees e inner join employees m
on e.salary = m.salary and e.employee_id <> m.employee_id;


-- find the job_id which got filled in 2nd half of any year again filled in the 1st half of the next year
select  * from 
(select job_id, month(hire_date),year(hire_date) yr from employees
where month(hire_date) between 7 and 12) a
join 
(
	select job_id, month(hire_date),year(hire_date) yr from employees
	where month(hire_date) between 1 and 6
) b
on  a.job_id = b.job_id and b.yr - a.yr = 1;

-- natural join
-- tables are joined naturally on common columns, join condition should not be specified
select region_name,country_name from regions natural join countries;

select * from employees e inner join departments d on e.department_id = d.department_id;
select * from employees e natural join departments d;




select nullif(12,12);

select ifnull(null,null);


use practice;


select * from emp;


use new_hr;
select * from employees
where salary in (select salary from employees group by salary having count(*) > 2)
order by salary;

select concat(a.first_name,' ',a.last_name) name , a.salary
from employees a, employees b
where a.salary = b.salary and a.employee_id <> b.employee_id; 


select date_format(hire_date,'%d'), dayname(hire_date) from employees;

-- stored procedures

use assignments;

-- get the details of employees working in deparment 20
DELIMITER //
create procedure spGetDetails(IN dept_id int)
BEGIN
	select * from employees where department_id = dept_id;
END //
DELIMITER ;

call sp_GetDetails(20);

DELIMITER //
create procedure spGetTotalEmployees(OUT total_emps int)
begin
	select count(employee_id) into total_emps from employees;
end //
DELIMITER ;

call spGetTotalEmployees(@total_emps);

select @total_emps as total_employees;


-- DCL

-- create user test and password test
create user 'test'@'localhost' identified by 'test';

select user from mysql.user;

-- grant permission to the user
grant all privileges on new_hr.job_grades to 'test'@'localhost';

show grants for 'test'@'localhost';

select user();

-- revoking
revoke all privileges on new_hr.job_grades from 'test'@'localhost';


-- grant create privileges
grant  create on hr.* to 'test'@'localhost';


-- grant insert privileges

grant insert on hr.* to 'test'@'localhost';

grant all on hr.* to 'test'@'localhost';

-- TCL -- 
/* 
commit
rollback
*/

/* if two people are accesing the same table and one is doing some actions
on the table with start transaction 
then the changes will not be visible to the other person */

start transaction;

select * from employees;

rollback; -- commit is used incase we want to persist the changes.

 /*
	note: Any transactions using start transaction, subsequent DDL,DCL transactions will commit the previous transactions
		because DDL, and DCL are auto commit.
 */


-- correlated update

use new_hr;
create table new_emp as select employee_id,first_name,department_id,job_id from employees;

alter table new_emp add department_name varchar(35);

update new_emp e
set department_name = (select department_name from departments where department_id = e.department_id);

select * from new_emp;

-- correlated delete
delete from new_emp e
where job_id = (select job_id from employees where employee_id = e.employee_id and employee_id = 109);


-- alter
 /* using alter we can add columns, constraints (PK,FK,CHECK,U). We cannot add not null using alter */
 
 -- first keyword used to add column at the first.
 alter table new_emp add col numeric(11,2) first;
 
 -- for other positions use after keyword
 alter table new_emp add col2 int after first_name;
 select * from new_emp;
 
 -- not null 
 alter table new_emp modify  col2 int not null; 

-- rename table
alter table new_emp rename emp_new;

-- drop column
alter table emp_new drop col;





use practice;

create table new_dept
(
	id int,
    name varchar(25)
);

alter table new_dept add primary key(id);
alter table new_dept modify column id int auto_increment;
--  alter table new_dept auto_increment=1001
insert into new_dept values(1001,'Prithivi'),(null,'Agni'),(null,'Tejas'),(null,'Trishul');

select * from new_dept;

alter table new_dept add column location varchar(15);

update new_dept
set location = 
case 
	when id = 1001 then 'Bangalore'
	when  id = 1002 then 'chennai'
	when id = 1003  then 'hyderabad'
    when id = 1004 then 'delhi'
end;

alter table new_dept rename column location  to place;

alter table new_dept rename dept_new;

alter table dept_new modify column id int;
alter table dept_new drop primary key;



use new_hr;
-- views
/*
	views can be of two types 
    1.) simple
    2.) complex
*/
create view v1 as select employee_id,first_name,last_name,salary,job_id
from employees where department_id = 60;

grant select on new_hr.v1  to 'test'@'localhost';

-- simple view using 1 table
create view v2 as select sum(salary) 'totsal' ,department_id
from employees where department_id is not null
group by department_id;

select * from v2;

start transaction;
delete from v2 where department_id = 70;
rollback;

-- complex view using joining two rows
create view  v3 as select region_name,country_name from regions natural join countries;

select * from v3;

-- delete cannot be possible
delete from v3;

-- view with checkoption
create view v4 as select * from employees where department_id = 90 with check option;

update v4 set department_id = 40;







use practice;



create table t1(id int);
insert into t1 values(1),(2),(3),(null),(null);

create table t2(id int);
insert into t2 values(1),(2),(1),(1),(null);


delete from t2;

create temporary table temp_t select t1.id from t1 inner join t2;
--  on t1.id = t2.id;

select t1.id,t2.id from t1 natural join t2;


