use new_hr;

-- create table job_grades
-- (grade_level char(1),
--  lowest_sal numeric(11,2),
--  high_sal numeric(11,2));

-- insert into job_grades
-- values ("A",1000,2999),
-- ("B",3000,5999),
-- ("C",6000,9999),
--  ("D",10000,14999),
--  ("E",15000,24999),
--  ("F",25000,40000);

-- subquery

/*
types
-----
single row  -> returns 1 row   (=,<>,>,<)
multiple row -> returns more than 1 row  (in,not in, any,all)
multiple column  
nested
correlated
select inside select
evaluating unknown through known 

rules
-----
sub query executes first
result will be used by outer query and then gets executed
subquery should be enclosed in the brackets.
*/

-- find out the employees who joined after lisa
select first_name,hire_date from employees 
where hire_date > (select hire_date from employees where first_name = 'lisa');

-- find out the department_name in which steven king is working
-- using sub-query
select department_name from departments
where department_id = (select department_id from employees where concat(first_name,last_name) = 'stevenking');

-- using join
select department_name from employees e inner join departments d
on e.department_id = d.department_id
and concat(first_name,last_name) = 'stevenking';

select * from employees;
-- self join using subqueries
-- find out the employees reporting to neena kochhar

-- using sub query

select * from employees e
where manager_id = (select employee_id from employees where concat(first_name,last_name) = 'neenakochhar');

-- using join
select concat(e.first_name,' ',e.last_name) full_name, e.manager_id from employees e, employees m
 where e.employee_id = m.manager_id
and concat(e.first_name,' ',e.last_name) = 'neena kochhar';


--  find out the grade od lex de haan using subquery
select grade_level from job_grades
where (select salary from employees where concat(first_name,' ',last_name) = 'lex de haan') between lowest_sal and high_sal;

-- find out employees working in the same department as hermann baer.
select concat(first_name,' ',last_name) full_name,department_id from employees
where department_id  = (select department_id from employees where concat(first_name,' ',last_name) = 'Neena kochhar')
and concat(first_name,' ',last_name) <> 'neena kochhar';

-- find out employees who are working in the same department as valli and lex
select concat(first_name,' ',last_name) full_name, department_id from employees
where department_id in (select department_id from employees where first_name in ('valli','lex'));

-- find out the department names where no employees are working

select department_name from departments 
where department_id not in (select distinct department_id from employees where department_id is not null);

-- find out department_name where no sa_rep working

select * from jobs;
select * from departments;
select * from employees;

-- if subquery returns empty set then there is most likely that the result of inner query has a null value
-- try to eliminate that.
select department_name from departments
where department_id  not in (select department_id from employees where job_id = 'sa_rep' and department_id is not null);

-- any , all

-- find out employees who joined after laura and susan
select first_name,hire_date
from employees where hire_date > any (select hire_date from employees  where first_name in ('laura','susan'));

select first_name,hire_date
from employees where hire_date > all (select hire_date from employees  where first_name in ('laura','susan'));


-- find out the employees who are taking maximum salaries in each job_id
select concat(first_name,' ',last_name) full_name,job_id,salary from employees where (salary,job_id)
 in (select max(salary),job_id from employees group by job_id);
 
 
 -- find out the job_id which is having maximum number of employees

select count(employee_id) total,job_id from employees group by job_id
having count(job_id) in (select max(a.cnt) from 
											(select count(job_id) cnt from employees group by job_id)a);


-- correlated subquery 
-- find out the employees who are getting more than the average salary with respect to their department
select * from employees e1 where salary > (select avg(salary) from employees e2 where e2.department_id = e1.department_id);

-- select department_id, avg(salary) avg_sal from employees where department_id is not null group by department_id;

select first_name,last_name,salary,department_id from employees e
where salary >  (select avg(salary) from employees where department_id = e.department_id);

-- using joins

select e.first_name,e.last_name,e.salary,e.department_id from employees e
inner join (select department_id ,avg(salary) avg_sal from employees group by department_id ) a
on e.department_id = a.department_id and e.salary > a.avg_sal;


-- group concat 
select department_id,group_concat(first_name) names from employees
group by department_id;



