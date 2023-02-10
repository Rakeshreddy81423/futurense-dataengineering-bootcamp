 use hr;
 
 -- CHANGE DELIMITER FROM ; TO //
 DELIMITER //
 create procedure getAllCountries()
 Begin
	select * from countries limit 1;
    select * from countries limit 1,1;
 End //
 
 -- AGAIN CHANGE DELIMITER FOR DEFAULT i.e ;
 DELIMITER ;
 
 -- calling the procedure
call getAllCountries();


show create procedure getAllCountries;

show procedure status like 'getAllCountries';

-- IN parameter
DELIMITER //
create procedure getOfficeByCountry(IN countryName varchar(255))
Begin
	select * from countries where country_name = countryName;
end//
DELIMITER ;

call getOfficeByCountry('USA');


use classicmodels;
 -- stored function
 
 delimiter //
 create function prac_fun(
	first_name varchar(20),
    last_name varchar(20)
 )
 returns varchar(50)
 deterministic
 begin
	declare full_name varchar(50);
    set full_name = concat(first_name,' ',last_name);
    return (full_name);
 end //
 
 delimiter ;
 
 select prac_fun(firstName,lastName) as full_name from employees;
 
 
 select *  from information_schema.routines ;
 
 
 /*
		delimiter redefinition
        // or $$ can be used
        1.) redefine delimiter
        2.) use ; in the procedure body
        3.) redefine delimiter ;
 */
 
 
-- create a simple procedure

delimiter //
create procedure simple_sp()
begin
	select ("simple procedure");
end //
delimiter ;

call simple_sp();

-- rules for variables
/*
	should be declared after begin statement
    each variable should be declared seperately
    
    note: Don't use column/table names as variables
*/

 -- 2.
 delimiter $$
 create procedure sp2(p1 int, p2 int)
 begin
	declare var numeric(11,2);
    set var = p1 * p2;
    select concat("product of",p1,p2,"=",var);
 end  $$
 delimiter ;
 
 call sp2(10,20);
 
 -- 3. create a procedure to pass employee_id as parameter and print salary for him
 delimiter //
 create procedure sp3(p_empno int)
 begin
	select salary from employees where employee_id = p_empno;
 end //
 delimiter ;
 
 call sp3(143);
 
 -- 4.) create a procedure to pass employee_id as parameter and print the first_name, last_name and department_name
 
 delimiter //
 create procedure sp4(p_empid int)
 begin
	select first_name,last_name,department_name from employees e inner join departments d
    using(department_id) where employee_id = p_empid;
 end //
 
 delimiter ;
 
 call sp4(101);


-- create a procedure to insert more rows in stages using a loop and if elseif else
create table odd_Even(slno int primary key, descn varchar(4) check(descn in('odd','even')));


-- while syntax
/*
  delimiter $$
  create procedure sp_name()
  begin
  declare ..;
  While <condition> do
	statement 1;
    statement 2;
  End while;
*/

-- IF syntax
/*
	if <codition> then 
        statement1;
	else 
        statement2;
	end if;
 */
 
 -- insert values to odd_even table using procedure
 delimiter //
 create procedure fillOddEven(num1 int, num2 int)
 
begin
	declare str varchar(4);
	while num1<=num2 do
		if mod(num1 ,2) = 0 then
			set str = 'even';
		else
			set str = 'odd';
		end if;
        
        insert into odd_Even values(num1,str);
        set num1 = num1 + 1;
	end while;
end//
delimiter ;

call fillOddEven(1,100);

select * from odd_Even;
 
 
 -- create a procedure to pass your birthdate as parameter
 -- print day of birth starting from birthdate upto currentdate
 
 create table tbl_bday(bday date, day_name varchar(10));
 delimiter //
 create procedure sp_birthdate(bday date)
 begin
	while year(bday) <= year(curdate()) do
		insert into tbl_bday values (bday,dayname(bday));
        set bday = date_add(bday, interval 1 year);
	end while;
 end//
 delimiter ;
 

call sp_birthdate('1998-07-08');

select * from tbl_bday;



-- show all the procedures in the db
select specific_name,routine_type from information_schema.routines where routine_schema = 'new_hr';
 
-- exceptional handling

delimiter //
create procedure sp_errorHandling(p_emp int)
begin
	declare sal numeric(11,2);
    select salary into sal from employees where employee_id = p_emp;
    if sal is null then
		signal sqlstate '45000' set message_text = "**Invalid empno**";
	else
		select sal;
	end if;
end//
delimiter ;

drop procedure sp_errorHandling;


call sp_errorHandling(1000);

/*
	parameter modes
    ----------
    in read
    out write
    inout readwrite
*/

-- inout
delimiter //
create procedure sp_inoutex( inout e_name varchar(20))
begin
	set e_name = lpad(e_name,10,'*');
end//
delimiter ;

-- to call inout procedure we need to create a variable to get the out value
 drop  procedure sp_inoutex;
set @inpt = "hello";

call sp_inoutex(@inpt);
select @inpt;


-- stored functions

/*\
	create function <function_name> ()
    returns datatype deterministic
    begin
		declare
		return
	end
*/

-- 1.)  create a function to pass employee_id as parameter to find bonus

delimiter $$
create function fun_hr1(p1 int)
returns numeric(11,2) deterministic
begin
	declare v1 numeric(11,2);
    declare v2 numeric(11,2);
    declare v3 varchar(20);
    select job_id,salary into v3,v1 from employees where employee_id = p1;
    if v3 = "SH_CLERK" then
		set v2 = 1.5* v1;
	elseif v3 = "SA_REP" then
		set v2 = 1.75 * v1;
	elseif v3 = "MK_MAN" then
		set v2 = 2.0 * v1;
	else
		set v2=v1;
	end if;
    return (v2);
end $$

delimiter ;

-- drop function fun_hr1;

select employee_id,salary,fun_hr1(employee_id) as bouns from employees;

-- create a function to pass employee_id as parameter and return joined in leap year or not

delimiter //
create function leap_join(p1 int)
returns varchar(10) deterministic
begin
	declare le varchar(10);
    declare year_of_join  int;
    select year(hire_date) into year_of_join from employees where employee_id = p1;
    
    if mod(year_of_join,4) = 0  and (mod(year_of_join, 400) = 0 or mod(year_of_join,100) <> 0) then
		set le = 'Leap';
    else
		set le = 'Not leap';
	end if;
    return le;
end //
delimiter ;



select employee_id,hire_date,leap_join(employee_id) as leap_or_not from employees;

-- find leap or not
select hire_date, date_format(concat(year(hire_date),'-12-31'),'%j') as 'days_of_year' from employees;


-- task
/*
	employee gets a joining bonus
    criteria
    ---------
    on ot before 15 of a month will be paid joining bonus
    on the last friday after 1 year
*/

                                                                                                                                                                                                                                                          



