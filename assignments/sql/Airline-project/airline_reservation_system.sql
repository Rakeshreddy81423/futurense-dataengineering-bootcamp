create database if not exists airline_db;

use airline_db;

use practice;
show tables;
select * from countries;



use hr;

select * from countries;


desc check_extent;

desc emp;
explain format = tree select empno,ename,deptno from check_extent natural join (select empno,ename,deptno from check_extent) e;

select current_timestamp();











