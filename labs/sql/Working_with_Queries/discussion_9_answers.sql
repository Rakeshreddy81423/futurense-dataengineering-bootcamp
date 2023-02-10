use hr;

-- 1.)
select count(distinct job_id) as number_of_jobs from employees;


-- 2.)
select sum(salary) as total_salary from employees;


-- 3.)
select min(salary) as min_salary from employees;

-- 4.)
select max(salary) as max_salary from employees;

-- 5.)
select avg(salary)as avg_salary, count(*) as total_employees from employees where department_id = 90;

-- 6.)
select min(salary) as min_salary, max(salary) as max_salary,sum(salary) as total_salary,avg(salary) as avg_salary  from employees;

-- 7.)
select job_id, count(*) as total_employees from employees group by job_id;

-- 8.)
select max(salary) - min(salary) as min_max_salary_diff from employees;

-- 9.)

select manager_id, min(salary) as lowest_salary from employees
group by manager_id;

-- 10.)
select department_id, sum(salary) as total_salary_payable from employees
group by department_id;


-- 11.)
select job_id , avg(salary) as avg_salary from employees
where job_id <> 'IT_PROG'
group by job_id;

-- 12.)

select job_id, min(salary) as min_salary, 
max(salary) as max_salary,sum(salary) as total_salary,
avg(salary) as avg_salary  from employees
where department_id = 90
group by job_id;


-- 13.)
select job_id, max(salary) as max_salary from employees
group by job_id
having max(salary) > 4000;

-- 14.)
select department_id, count(*) as total,avg(salary) as avg_salary from employees
group by department_id
having total > 10;







