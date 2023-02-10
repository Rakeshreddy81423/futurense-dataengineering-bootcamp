select dayname(curdate()),last_day(current_date()),sysdate(),current_timestamp(),datediff(curdate(),'2020-02-3');



select * from (select ename,deptno,sal, rank() over(partition by deptno order by sal desc) as rn from emp) e
where rn = 1;

select * from (select ename, job, sal, rank() over(partition by job order by sal desc) as rn from emp)e where rn = 1;

-- senior most manager
select m.ename, e.job, m.hiredate from emp e inner join emp m 
on e.empno = m.mgr where e.job = 'Manager'
order by hiredate
limit 1;

-- highest paid salesman
select empno, ename, sal, job from emp 
where job = 'salesman'
order by sal desc
limit 1;

-- lowest paid clerk
select empno, ename, sal, job from emp 
where job = 'clerk'
order by sal 
limit 1;

-- junior most clerk
select empno, ename, sal, job, hiredate from emp 
where job = 'clerk'
order by hiredate desc
limit 1;

-- Display employees who is taking more salary than average salary in their respective jobs

with cte as
(select empno,ename,sal,job,  avg(sal) over(partition by job) avg_sal from emp
)
select * from cte where sal > avg_sal;

-- . Display employee name,sal,sal difference for every employee
 -- And successive employee
 

select ename,sal,sal - lead(sal) over() as lead_sal from emp;

 -- practice session 2
 -- Find the number of days difference between  1st analyst and 2nd analyst 

with cte as
(
	select empno,ename,job,sal,hiredate,lead(hiredate) over(order by hiredate) ld_sal
	from emp where job = 'analyst'
    limit 1
)
select  abs(datediff(hiredate,ld_sal)) as date_difference from cte;

-- Find the number of days difference between 1st Manager And 2nd Manager
with cte as
(
	select ename,job,hiredate,lead(hiredate) over(order by hiredate) as ld 
	from emp where job = 'manager'
	limit 1
)
select abs(datediff(hiredate,ld)) as diff from cte;

-- Find the salary difference between  1st SALESMAN and 2nd SALESMAN 

select empno,ename,sal,hiredate,lead(hiredate) over(order by hiredate) as ld,abs(datediff(hiredate,lead(hiredate) over(order by hiredate)))  from emp
where job = 'salesman'
limit 1;

    

