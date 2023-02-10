use hr;

-- Write a query to display the name (first_name, last_name) and salary
-- for all employees whose salary is not in the range $10,000 through $15,000.
select concat(first_name," ",last_name)as "Name" , salary from employees where not (salary >= 10000 and salary <=15000);

-- Write a query to display the name (first_name, last_name) and salary for all employees whose salary is not in the 
-- range $10,000 through $15,000 and are in department 30 or 100.

select concat(first_name," ",last_name)as "Name" , salary 
from employees where not (salary >= 10000 and salary <=15000) and (DEPARTMENT_ID = 30 or DEPARTMENT_ID = 100);

-- Write a query to display the name (first_name, last_name) and hire date for all employees who were hired in 1987
select concat(first_name," ",last_name) as "Name", hire_date from employees where year(hire_date) = '1987';

-- Write a query to display the first_name of all employees who have both "b" and "c" in their first name.
select first_name from employees where first_name like "%b%c%";

-- Write a query to display the last name, job, and salary for all employees whose job is that of a Programmer or a Shipping Clerk,
-- and whose salary is not equal to $4,500, $10,000, or $15,000.
select e.last_name, j.job_title, e.salary 
from employees e inner join jobs j on e.job_id = j.job_id
 where j.job_title in ("Programmer","Shipping Clerk") and e.salary not in (4500,10000,15000);
 
 -- Write a query to display the last name of employees having 'e' as the third character.
 select last_name from employees where last_name like "__e%";
 
 -- Write a query to display the last name of employees whose names have exactly 6 characters.
 select last_name from employees where length(concat(first_name,last_name))=6;
 
 -- Write a query to select all record from employees where last name in 'BLAKE', 'SCOTT', 'KING' and 'FORD'.
 select * from employees where last_name in ('blake','scott', 'king','ford');
 
 
