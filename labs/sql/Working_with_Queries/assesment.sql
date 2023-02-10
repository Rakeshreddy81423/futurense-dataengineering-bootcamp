use hr;

-- Q. 1 )
select employee_id, 
(select sum(salary)  from employees)as Total_salary,
(select min(salary)  from employees) as Min_salary,
(select max(salary)  from employees) as Max_salary,
(select round(avg(salary))  from employees) as Average_salary
from employees
where department_id = 90;



-- Q. 2)
select employee_id, employee_name, salary,department_name
from
(
	select employee_id, concat(first_name," ",last_name) as employee_name, salary, department_id ,department_name,
	dense_rank() over (partition by department_id order by salary desc) as dn
	from employees inner join departments
	using(department_id)

) data_table
where dn <=3
order by department_name;



select * from tree;

--  Q.4)
select id, 
case 
	when p_id is null then 'Root'
    when id in (select distinct p_id from tree where p_id is not null) then 'inner'
    else 'leaf'
end as type
from tree;

-- Q.3)
create table Logs
(
id int auto_increment primary key,
num varchar(10)
);

insert into Logs values (1,1),(2,1),(3,1),(4,2),(5,1),(6,2),(7,2);

select * from logs;







 
