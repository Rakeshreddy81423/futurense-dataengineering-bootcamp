use hr;

select * from employees;

create table emp_stats
(
	emp_count int
);
insert into emp_stats(select count(employee_id) from employees);

select * from emp_stats;


-- procedures will be available in
/*
informations.routines 

Exporting db
------------
tables/views/triggers can be exported but not routines with the following command

mysqldump -u root -p hr> hrdump.sql

to include routines

mysqldump -u root -p --routines hr > hrdump.sql


Importing sql files
-------
mysql -u root -p <database_name> < hrdump.sql

*/

create trigger incrementEmpCount
before insert on employees
for each row
update emp_stats
set emp_count = emp_count+1;


insert into employees values(209,'Rakesh1','Reddy1','ra@gmail.com','975424563','2022-09-10','IT_PROG',20000,0,100,60);
select * from emp_stats;

select * from employees;


show triggers;



-- create a trigger to insert into retired table whenever delete happens on employees table

create table retired
(
	emp_name varchar(20)
);


delimiter $$
create trigger trig_retired
before delete on sam_emp
for each row 
begin
	insert into retired values(old.first_name);
end $$
delimiter ;
-- working
-- start transaction;
-- delete from sam_emp where emp_no = 2;

-- select * from retired;

-- rollback;

select * from sam_emp;


create table date_table(slno int primary key, date1 date check(date1 <=curdate()));

create table date_table (slno int primary key, date1 date);

delimiter //
create trigger trig_check
before insert on date_table
for each row
begin 
	if new.date1 > curdate() then
		signal sqlstate '45000' set message_text = "*date1 <= curdate()*";
	end if;
end//
delimiter ;

drop trigger trig_check;
insert into date_table values(1,'2023-01-31');

select * from date_table;
-- -------
delimiter $$
create trigger trig_redu
before update on employees
for each row
begin
	if new.salary < old.salary then
		signal sqlstate '45000' set message_text="**beware!I want hike**";
	end if;
end $$

delimiter ;

update employees set salary=salary-100;

-- --------
create table account
(
	accno int primary key,
    name varchar(20),
    balance numeric(11,2)
);


create table trans
(
	accno int,
	wd numeric(11,2),
    dep numeric(11,2),
    foreign key (accno)
    references account(accno)
);

-- create a trigger to update the balance in the account table whenever wd(withdrawl),dep(deposit) happens on trans table
delimiter //
create trigger trig_bal
before insert on trans
for each row
begin
	if new.dep is not null then
		update account set balance = balance + new.dep where accno = new.accno;
	else
		update account set balance = balance - new.wd where accno = new.accno;
	end if;
end //

delimiter ;

insert into account values(1,'rakesh',1000);
insert into trans values(1,100,null);

insert into trans values(1,null,200);
select * from account;

		
use hr;

select *, count(salary) over(), count(salary) over(partition by department_id) from employees;





