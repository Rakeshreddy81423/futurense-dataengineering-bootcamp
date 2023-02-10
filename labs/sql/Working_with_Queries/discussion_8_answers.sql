
use hr;

-- Q.1) Write a query to find the addresses (location_id, street_address, city, state_province, country_name) of all the departments.
select l.location_id, street_address, city, state_province, country_name
from departments d inner join locations l
on d.location_id = l.location_id
inner join countries c on l.country_id = c.country_id;

-- Q.2) Write a query to find the name (first_name, last name), department ID, and department name of all the employees.
select first_name,last_name,d.department_id,department_name
from departments d inner join employees e
on d.department_id = e.department_id;

-- Q.3)  Write a query to find the name (first_name, last_name), job, department ID, and name 
-- of the employees who work in London.

select concat(first_name,last_name) as name, d.department_id,
job_title
from departments d inner join locations l 
on d.location_id = l.location_id
inner join employees e
on e.department_id = d.department_id 
inner join jobs j
on e.job_id = j.job_id
where city = 'London';

-- Q.4) Write a query to find the employee id, name (last_name) 
-- along with their manager_id, and name (last_name).

select e.employee_id, e.last_name, m.manager_id,m.last_name
from employees e inner join employees m
on e.employee_id = m.manager_id;

-- Q.5) Write a query to find the name (first_name, last_name) and hire date of the employees 
-- who were hired after 'Jones'.
select concat(first_name,last_name) as name, hire_date
from employees
where hire_date >
(select hire_date from employees where last_name like 'jones%');


-- Q.6) Write a query to get the department name 
-- and number of employees in the department.
select department_name, count(*) as number_of_employees
from departments d inner join employees e
on d.department_id = e.department_id
group by department_name;

-- Q.7)Write a query to find the employee ID, job title, number of days between the ending date 
-- and the starting date for all jobs in department 90.
select jh.employee_id, j.job_title, to_days(end_date) - to_days(start_date) as 
days_worked from job_history jh inner join jobs j 
on jh.job_id = j.job_id
where jh.department_id = 90;

-- Q.8) Write a query to display the department ID and name and 
-- first name of the manager.
select d.department_id,concat(m.first_name,m.last_name) as name
from departments d left join employees m
on d.manager_id= m.employee_id;

-- Q.9) Write a query to display the department name, manager name, and city.

select department_name, concat(first_name,last_name), city
from departments d inner join locations l on
d.location_id= l.location_id inner join
employees e  where d.manager_id = e.employee_id;


-- Q.10) Write a query to display the job title and average salary of employees.
select job_title,avg(salary) as avg_salary
from employees e inner join jobs j 
on e.job_id = j.job_id
group by job_title;

-- Q. 11) Write a query to display job title, employee name, and the difference between the salary of the employee 
-- and minimum salary for the job
select j.job_title, concat(first_name,last_name) as employee_name,salary -  min_salary as salary
from employees e inner join jobs j
on e.job_id = j.job_id;

-- Q.12) Write a query to display the job history of any employee who is 
-- currently drawing more than 10000 of salary.
select jh.*
from employees e inner join job_history  jh
on e.employee_id = jh.employee_id
where e.salary > 10000;

-- Q. 13) 
-- Write a query to display department name, name (first_name, last_name), hire date, the salary of the manager 
-- for all managers whose experience is more than 15 years.
select department_name , concat(e.first_name,e.last_name) as name , e.hire_date,e.salary
from departments d inner join employees e 
on d.manager_id =  e.manager_id
where  (year(curdate()) - year(hire_date) )> 15;









 



