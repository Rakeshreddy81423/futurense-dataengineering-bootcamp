-- 1.)
select concat(first_name," ",last_name) as name, salary from employees
where salary > 
(select salary from employees where last_name = 'Bull');

-- 2.)
select concat(first_name,' ',last_name) as name from employees
where department_id in 
(select department_id from departments where department_name = 'IT');

-- 3.)
select concat(first_name,' ',last_name) as name from employees where manager_id in 
(select distinct manager_id from departments where department_name in 
(select distinct department_name from departments where location_id in
(select location_id from locations where country_id in 
(select country_id from countries where country_id = 'us'))));

-- 4.) 
select concat(first_name,' ',last_name) as name from employees
where employee_id in (select manager_id from departments);

-- 5.)

select concat(first_name,' ',last_name) as name, salary from employees
where salary  > (select avg(salary) as salary from employees);

-- 6.)*
select concat(first_name,' ',last_name)as name, salary from employees e
where salary in (select min_salary from jobs where job_id = e.job_id);

-- 7.)*
select concat(first_name,' ',last_name) as name, salary from employees where 
salary > (select avg(salary) from employees ) and department_id in (select department_id from departments where department_name like 'IT%');

 -- salary > avg (salary) employees of IT department
 select concat(first_name,' ',last_name) as name, salary from employees where salary > 
 (select avg(salary) from employees where department_id in 
 (select department_id from departments where department_name like 'IT%')) and department_id in 
 (select department_id from departments where department_name like 'IT%');
 
 
-- 8.)
select concat(first_name,' ',last_name) as name from employees
where salary > (select salary from employees where last_name = 'Bell');

-- 9.) 
select concat(first_name,' ',last_name) as name, salary from employees
where salary = (select min(salary) as salary from employees);

-- 10.) 

select concat(first_name,' ',last_name) as name, salary from employees
where salary > 
(select avg(salary) as salary from employees);


-- 11.)
select concat(first_name,' ',last_name) as name, salary from employees
where salary > 
(select max(salary) as salary from employees where job_id = 'SH_CLERK')
order by salary;

-- 12.)
select concat(first_name,' ',last_name) as name from employees 
where employee_id  not in (select distinct manager_id from departments);

-- 13.) 
select employee_id, first_name, last_name, department_name from departments
inner join employees using(department_id);

-- 14.)
select employee_id, first_name, last_name, salary from employees e
where salary > 
(select avg(salary) as salary from employees where department_id = e.department_id);

-- 15.)
select * from employees
where employee_id % 2 = 0;

-- 16.)
select concat(first_name,' ',last_name) as name, salary from employees
order by salary desc
limit 4,1;

-- 17.)
select concat(first_name,' ',last_name) as name, salary from employees
order by salary 
limit 3,1;

-- 18.)
select employee_id, name, salary
from (select employee_id,concat(first_name,' ',last_name) as name, salary from employees order by employee_id desc limit 10) a
order by employee_id;


-- 19.) 
with cte as 
(
	select department_id, count(*) as total from employees
    group by department_id order by department_id
)
select department_id, department_name from departments where department_id not in (select department_id from cte);

-- 20.)
select distinct salary from employees
order by salary desc
limit 3;

-- 21.)
select distinct salary from employees
order by salary 
limit 3;

-- 22.) find the 10th max salary
with cte as 
(select salary , dense_rank() over(order by salary desc) as dn
from employees)
select salary from cte where dn = 10;





-- class work 12/12/2022
use classicmodels;

-- 1.) 
select customerNumber, count(*) as returned_count
from orders where status in ('disputed',  'resolved')
group by customerNumber;



-- 2.)
select year(orderdate) as year,count(*) as returned_count from orders 
where status in ('disputed', 'resolved')
group by year(orderdate);

-- 3.)
select *,returned_count /total_orders * 100 as percentage from
(select  customerNumber,total_orders,
case when returned_count is null then 0 else returned_count end as returned_count
from
(
	select customerNumber, count(*) as total_orders
	from orders
	group by customerNumber
) a 
left join (
	select customerNumber, 
    count(*) as returned_count
	from orders where status in ('disputed',  'resolved')
	group by customerNumber
)b
using(customerNumber)) c;










