use hr;

show tables;

-- first name and last name
select first_name as "First name", last_name as "Last name" from employees;

-- unique department id
select distinct department_id from employees;

-- pf calculation
select first_name as "First name", last_name as "Last name", salary, round(salary * 0.15,2) as PF from employees;

-- min and max salaries from employee table
select min(salary) as minimum_salary, max(salary) as maximum_salary from employees;

-- avg salary and count of employees
select avg(salary) as avg_salary, count(*) as total_employees from employees;

 -- first name in uppercase
 select upper(first_name) as "First name" from employees;
 
 -- first three characters in the first name
 select left(first_name,3) as first_three_characters from employees;
 
 -- first 10 records 
 select * from employees limit 10;
 
 -- monthly salary with 2 decimals
 select round(salary,2)as monthly_salary from employees;
 
 -- first_name last_name department_id of of all employees in department 30 or 100
 select concat(first_name," ",last_name) as full_name, department_id from employees where department_id = 30 or department_id = 100
 order by department_id;
 
 
 select job_title from jobs where job_id like "%\_clerk";
 
select now();                                                                                                                                                                                            sssss                                                                             ss