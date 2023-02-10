use hello;

create table employee
(
	id int,
    name varchar(20),
    age int,
    city varchar(20),
    salary int,
    gender varchar(10),
    manager_id int,
    department_id int
);

insert into employee values (1,'rak', 20, 'nellore', 10000,'Male',1, 1), 
(2,'rakesh', 22, 'krishna', 12000,'Male',1, 1),
(3,'mahesh', 23, 'prakasam', 2500000,'Male',1, 1),
(4,'nagini', 25, 'nalonda', 2000000,'Female',1, 1),
(5,'ramya', 22, 'prakasam', 2500000,'Female',1, 2),
(6,'ramesh', 23, 'hyderabad', 20000,'Male',1,2);


create table department
(
	id int,
    name varchar(20)
);

insert into department values (1,'IT'), (2,'Medicine');
alter table employee
add constraint `fk_departmentid` foreign key(department_id) references department(id);

alter table employee
add constraint `pk_employee_id` primary key(id);


alter table department rename column name to dept_name;

(
	select name, dept_name, age, salary from
	employee e  inner join department d  on e.department_id = d.id
	where salary >=1500000
)
union
(
	select Null as name, dept_name, age, salary from
	employee e inner join department d on e.department_id = d.id
	where salary < 1500000
);

select truncate(5.235,2) from dual;


select * from employee;
select * from department;


insert into employee values (10,'babri', 26, 'nellore', 2000000,'Female',1, 1);



select case when salary >= 1500000 then name else Null end as name,
dept_name, age, salary
from employee e inner join department d on e.department_id = d.id
order by salary desc, if(salary > 1500000,name, age) asc;


select 
'average' as filter , 
avg(case when age>= 20 and age<30 then salary  end) as '20- 30',
avg(case when age >= 30 and age < 40 then salary end) as '30-40'
from employee
union
select 'min',
min(case when age>= 20 and age<30 then salary  end),
min(case when age >= 30 and age < 40 then salary end)
from employee
union 
select 'max',
max(case when age>= 20 and age<30 then salary  end),
max(case when age >= 30 and age < 40 then salary end)
from employee;


select '20-30' as age_group, avg(salary) as average, min(salary) as min_salary, max(salary) as max_salary 
from employee where age>=20 and age <30
union
select '30-40' as age_group, avg(salary) as average, min(salary) as min_salary, max(salary) as max_salary 
from employee where age>=30 and age <40;

-- class work 15-12-2022

-- union ----
select 'average' as operation, 'age' as field,
floor(avg(case when age between 20 and 25 then age end )) as '20-25',
floor(avg(case when age between 25 and 30 then age end )) as '25-30'
from employee
union
select 'min' as operation, 'age' as field,
min(case when age between 20 and 25 then age end),
min(case when age between 25 and 30  then age end)
from employee
union
select 'max' as operation, 'age' as field,
max(case when age between 20 and 25 then age end),
max(case when age between 25 and 30  then age end)
from employee
union
select 'average' as operation, 'sal' as field,
floor(avg(case when age between 20 and 25 then salary end )) as '20-25',
floor(avg(case when age between 25 and 30 then salary end )) as '25-30'
from employee
union
select 'min' as operation, 'sal' as field,
min(case when age between 20 and 25 then salary end),
min(case when age between 25 and 30  then salary end)
from employee
union
select 'max' as operation, 'sal' as field,
max(case when age between 20 and 25 then salary end),
max(case when age between 25 and 30  then salary end)
from employee;

-- vertical stitch using union -- 

 
select '20-25' as age_group,
floor(avg(case when age between 20 and 25 then age end)) as 'average_age',
min(case when age between 20 and 25 then age end) as 'min_age',
max(case when age between 20 and 25 then age end) as 'max_age',
floor(avg(case when age between 20 and 25 then salary end)) as 'average_sal',
min(case when age between 20 and 25 then salary end) as 'min_sal',
max(case when age between 20 and 25 then salary end) as 'max_sal'

from employee
union
select '25-30' as age_group,
floor(avg(case when age between 25 and 30 then age end)) as 'average_sal',
min(case when age between 25 and 30 then age end) as 'min_sal',
max(case when age between 25 and 30 then age end) as 'max_sal',
floor(avg(case when age between 25 and 30 then salary end)) as 'average_sal',
min(case when age between 25 and 30 then salary end) as 'min_sal',
max(case when age between 25 and 30 then salary end) as 'max_sal'
from employee;



select round(23.5554,2);









