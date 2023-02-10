use classicmodels;
show tables;

-- Q .1)
select c1.city,c1.customername,c2.customername from customers c1 inner join customers c2 on c1.city = c2.city
 where c1.customername <> c2.customername
 order by c1.city;

-- Q.2) 
select productcode,productname,textdescription from products p left join productlines pl  on p.productline = pl.productline;

-- Q.3)
select o.ordernumber, o.status,sum(quantityordered * priceeach) from orders o 
left join orderdetails od on o.ordernumber = od.ordernumber
group by o.ordernumber,o.status
order by o.ordernumber;


-- Q.4 )
select * from orders o 
inner join orderdetails od on o.ordernumber = od.ordernumber
inner join products  p on od.productcode = p.productcode
order by od.ordernumber, od.orderlinenumber;

-- Q.5)
select * from orderdetails od inner join orders o on od.ordernumber = o.ordernumber
inner join products p on od.productcode = p.productcode
inner join customers c on o.customernumber = c.customernumber
order by o.ordernumber,od.orderlinenumber;

-- Q.6) Write a query to find the sales price of the product whose code is S10_1678 that is less than 
 -- the manufacturer’s 
 -- suggested retail price (MSRP) for that product as follows:
select o.ordernumber, p.productname, p.msrp, o.priceeach
from products p  inner join  orderdetails o 
on p.productcode = o.productcode
where p.productcode = 'S10_1678' and priceeach < msrp;

-- Q.7) Each customer can have zero or more orders while each order must belong to one customer. 
 -- Write a query to find all the customers and their orders as follows:
select c.customernumber, c.customername, o.ordernumber,o.status 
from customers c left join orders o 
on c.customernumber = o.customernumber
order by c.customernumber;

-- Q.8)  Write a query that uses the LEFT JOIN to find customers who have no order:
select c.customernumber, c.customername, o.ordernumber,o.status 
from customers c left join orders o 
on c.customernumber = o.customernumber
where o.ordernumber is null;








