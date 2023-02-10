use classicmodels;

-- discussion 10 -- 
-- 1.
/*
Create a stored procedure named getEmployees() 
to display the following employee and their office info: name, city, state, and country. 
*/

DELIMITER //
create procedure getEmployees()
begin
	select concat(firstName,' ',lastName) as name, city, state, country
    from employees e left join offices o on e.officeCode = o.officeCode;
end //
DELIMITER ;

call getEmployees();


-- 2. 
/*
	Create a stored procedure named getPayments() that prints the following 
    customer and payment info:customerName, checkNumber, paymentDate, and amount.
*/

DELIMITER //
create procedure getPayments()
begin
	select customerName,checkNumber,paymentDate,amount
    from customers inner join payments using(customerNumber);
end //
DELIMITER ;

call getPayments();


-- discussion 13 -- 

/*
	Write a stored function called computeTax that calculates income tax based on the salary for every worker in the Worker table as follows:

	10% - salary <= 75000
	20% - 75000 < salary <= 150000
	30% - salary > 150000
Write a query that displays all the details of a worker including their computedTax.
*/

use org;

DELIMITER //
create function computeTax(
	salary int
)
returns int
deterministic
begin
	declare tax int;
    if salary <= 75000 then
		set tax = salary*0.1;
	elseif 75000 < salary <=150000 then
		set tax = salary * 0.2;
	else
		set tax = salary *0.3;
	end if;
    
    return tax;
end //
DELIMITER ;


select concat(first_name,' ',last_name) as name, salary, computeTax(salary) as income_tax from worker;


-- 2.
/*
	Define a stored procedure that takes a salary as input and returns the calculated income tax amount for the input salary. 
    Print the computed tax for an input salary from a calling program. 
    (Hint - Use the computeTax stored function inside the stored procedure)
*/


DELIMITER //
create procedure getTaxDetails(IN salary int)
begin
	select computeTax(salary) as tax;
end //
DELIMITER ;


call getTaxDetails(1200000);







