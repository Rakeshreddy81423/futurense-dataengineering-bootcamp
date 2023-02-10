use classicmodels;

-- select customerNumber, customerName, orderNumber, sum(quantityOrdered * priceEach) as orderAmount
-- from 
-- orders o  inner join customers c
-- using (customerNumber)
-- inner join orderdetails od using (orderNumber)
-- group by orderNumber
-- having orderAmount >  60000;



-- Q. 1 )
select customerNumber, checkNumber, amount
from  payments where amount > 
(
	select avg(amount) as amount from payments
);

-- Q.2) 
 select customerName from customers
 where customerNumber not in 
 (
	select customerNumber from orders
 );
 
 
 -- Q.3) 
 select max(items),min(items),floor(avg(items))
 from (select count(orderNumber) as items from orderdetails group by orderNumber) tbl;
 
 -- Q.4) 
 select productName, buyPrice
 from products 
 where buyPrice > 
 (
	select avg(buyPrice)
    from products
 );
 
 -- Q.5)

 select orderNumber, sum(quantityOrdered * priceEach) as total 
 from orderDetails 
 group by orderNumber
 having total > 60000;

 
-- Q.6) 
select distinct customerNumber, customerName
 from customers c inner join orders o
 using (customerNumber)
 where exists
 ( 
	 select orderNumber, sum(quantityOrdered * priceEach) as total 
	 from orderDetails 
     where orderNumber = o.orderNumber
	 group by orderNumber
	 having total > 60000
);

-- Q.7)


select productCode , round(sum(quantityOrdered * priceEach)) as total
from orderDetails od inner join orders o
using (orderNumber)
where year(orderDate) = '2003'
group by productCode
order by total desc
limit 5;


-- Q. 8)
select productName, sales
from products inner join
(
	select productCode , round(sum(quantityOrdered * priceEach)) as sales
	from orderDetails od inner join orders o
	using (orderNumber)
	where year(orderDate) = '2003'
	group by productCode
	order by sales desc
	limit 5
)topfive2003
using (productCode);


-- Q. 9)
select customerNumber, sales,
case 
	when sales> 100000 then 'Platinum'
    when sales between 10000 and 100000 then 'Gold'
    when sales< 10000 then 'Silver'
end as customerGroup
from
(
	select c.customerNumber, round(sum(quantityOrdered * priceEach)) as sales
	from customers c inner join
	orders o  using(customerNumber)
	inner join orderDetails od
	using(orderNumber) 
	where year(orderDate) = '2003'
	group by c.customerNumber
) sales2003
order by customerNumber;

 -- Q. 10)
 select customerGroup, count(*) as groupCount
 from (
	 select customerNumber, sales,
	case 
		when sales> 100000 then 'Platinum'
		when sales between 10000 and 100000 then 'Gold'
		when sales< 10000 then 'Silver'
	end as customerGroup
	from
	(
		select c.customerNumber, round(sum(quantityOrdered * priceEach)) as sales
		from customers c inner join
		orders o  using(customerNumber)
		inner join orderDetails od
		using(orderNumber) 
		where year(orderDate) = '2003'
		group by c.customerNumber
	) sales2003
	order by customerNumber
)groupTable
group by customerGroup;
 
 select * from orderdetails inner join orders;
 
