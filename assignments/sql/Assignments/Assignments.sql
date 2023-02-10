-- create database assignments;


/*DDL table creation Excercise */
use assignments;


create table patient
(
	pid int(7) not null unique,
    p_name varchar(30) not null 
);
alter table patient add constraint `PK_patient` primary key(pid);
create table treatment
(
	tid int(7) not null unique,
    t_name varchar(30) not null 
);

alter table treatment add constraint `PK_treatment` primary key(tid);

create table patient_treatment
(
	pid_pt int(7) not null,
    tid_pt int(7) not null,
    date   datetime not null
    
);

alter table patient_treatment add constraint `PK_patient_treatment` primary key(pid_pt,tid_pt);
alter table patient_treatment add constraint `FK_patient_patienttreatment` foreign key(pid_pt) references  patient(pid); 
alter table patient_treatment add constraint `FK_patient_patienttreatment_2` foreign key(tid_pt) references  treatment(tid); 


-- Assignment-3
/* DDL Alter & Drop Excercise */

-- 1
alter table patient modify column p_name varchar(35);

-- 2
alter table patient_treatment add column dosage numeric not null default 0 check (dosage <=99);

-- 3
alter table treatment rename column t_name to treatment_name;

-- 4 and 5
alter table treatment drop primary key;
alter table patient_treatment drop constraint `FK_patient_patienttreatment`;
alter table patient_treatment drop constraint `FK_patient_patienttreatment_2`;
drop table treatment;

-- Assignment - 4
/* DML Insert Update Delete Excercises */
create table student
(
	sid int(5) not null unique,
    s_fname varchar(20) not null,
    s_lname varchar(30) not null
);

alter table student add constraint `PK_student` primary key(sid);

create table course
(
	cid int(6) not null,
    c_name varchar(30) not null
);
alter table course add constraint `PK_course` primary key(cid);

create table course_grades
(
	cgid  int(7) not null unique,
    semester char(4) not null,
    cid int(6) not null,
    sid int(5) not null,
    grade char(2) not null
);

alter table course_grades add constraint `PK_coursegrades` primary key(cgid);

alter table course_grades add constraint `FK_course_coursegrades` foreign key(cid)
references course(cid);

alter table course_grades add constraint `FK_course_coursegrades_2` foreign key(sid)
references student(sid);

insert into  student(sid,s_fname,s_lname) 
values (12345,'Chris','Rock'),(23456,'Chris','Farley'),
(34567, 'David','Spade'),
(45678,'Liz','Lemon'),(56789,'Jack', 'Donaghy');

insert into course (cid,c_name)
values 
(101001, 'Intro to Computers'),
(101002, 'Programming'),
(101003,'Databases'),
(101004 ,'Websites'),
(101005 ,'IS Management');

insert into course_grades (cgid,semester,cid,sid,grade)
values (2010101,'SP10', 101005, 34567, 'D+'),
(2010308,'FA10', 101005, 34567, 'A-'),(2010309, 'FA10', 101001, 45678, 'B+'),
(2011308, 'FA11' ,101003, 23456,'B-'),(2012206 ,'SU12', 101002, 56789 , 'A+');

-- 3
alter table student modify column s_fname varchar(30);

-- 4 
alter table course add column faculty_lname varchar(30) not null default 'TBD';

-- 5 
update course set faculty_lname = 'Potter',c_name = 'Intro to Wizardry' 


where cid = 101001;

-- 6
alter table course rename column c_name to course_name;

-- 7 
select * from course;

set sql_safe_updates = 0;
delete from course where course_name = 'websites';


-- 8
alter table student drop primary key;
alter table course_grades drop constraint `FK_course_coursegrades_2`;
drop table student;

-- 9
alter table course_grades drop constraint `FK_course_coursegrades`;
truncate table course;
select * from course;

-- 10
alter table course_grades drop constraint `FK_course_coursegrades`;
alter table course_grades drop constraint `FK_course_coursegrades_2`;


-- Assignment 5 

-- 1
select first_name,last_name,job_id,salary from employees
where first_name like 's%';

-- 2
select * from employees 
where salary = (select max(salary) from employees);

-- 3

select * from employees
where salary = (select distinct (salary)
from employees
order by salary desc
limit 1,1);

-- 4
with cte as
(select concat(first_name,' ',last_name) as name, salary,
dense_rank() over(order by salary desc) dr
from employees)
select * from cte where dr = 2 or dr = 3;

-- 5
select concat(e.first_name,' ',e.last_name) as name,e.salary,
 concat(m.first_name,' ',m.last_name) as manager_name, m.salary as manager_salary from
employees e left join employees m 
on e.manager_id = m.employee_id;

-- 6
select manager_id,count(employee_id) as total from employees
group by manager_id
order by total desc;

-- 7
select department_id, count(employee_id) as total from employees
group by department_id
order by total desc;

-- 8
select year(hire_date) as year, count(employee_id) as total
from employees
group by year;

-- 9
select concat(min(salary),' to ',max(salary)) as sal_range from employees;
-- 10
with cte1 as
(SELECT first_name, salary, NTILE(3) over(partition by salary) as 'nog'
from employees)
select nog, concat(min(salary), " to ", max(salary)) as 'salRange', count(*) as count
from cte1
group by nog
;
-- 11
select * from employees where first_name like '%an%';

-- 12 
select concat(first_name,'-',last_name,'-',phone_number) as format from employees;

-- 13
select * from employees
where monthname(hire_date) = 'August';

-- 14
select * from employees where salary > 
(select avg(salary) from employees);

-- 15
select department_id,max(salary) as max_salary from employees
group by department_id;

-- 16 
select * from employees order by salary 
limit 5;

-- 17
select * from employees where year(hire_date) between 1980 and 1989;

-- 18
select reverse(first_name) rev_f, reverse(last_name) rev_l from employees;

-- 19
select * from employees where day(hire_date) between 16 and 31;

-- 20

select mgr.first_name, mgr.department_id, emp.first_name, emp.department_id
from employees as emp inner join employees as mgr
ON emp.manager_id = mgr.employee_id and emp.department_id <> mgr.department_id
;





