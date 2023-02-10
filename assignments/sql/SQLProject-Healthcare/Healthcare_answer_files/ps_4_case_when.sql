use healthcare;

/*
1.) 
	“HealthDirect” pharmacy finds it difficult to deal with the product type of medicine being displayed in numerical form, they want the product type in words. 
    Also, they want to filter the medicines based on tax criteria. 
Display only the medicines of product categories 1, 2, and 3 for medicines that come under tax category 
I and medicines of product categories 4, 5, and 6 for medicines that come under tax category II.

*/


select medicineID,companyName,productName,
case 
	when productType = 1 then 'Generic'
    when  productType = 2 then 'Patent'
    when  productType = 3 then 'Reference'
    when  productType = 4 then 'Similar'
    when  productType = 5 then 'New'
    when  productType = 6 then 'Specific'
end as productType,
taxCriteria
from medicine
where (taxCriteria = 'I' and productType  in (1,2,3)) or (taxCriteria = 'II' and productType in (4,5,6));


/* 
2.) 
'Ally Scripts' pharmacy company wants to find out the quantity of medicine prescribed in each of its prescriptions.
Write a query that finds the sum of the quantity of all the medicines in a prescription and if the total quantity of medicine is less than 20 tag it as “low quantity”.
 If the quantity of medicine is from 20 to 49 (both numbers including) tag it as “medium quantity“ and if the quantity is more than equal to 50 then tag it as “high quantity”.
Show the prescription Id, the Total Quantity of all the medicines in that prescription, and the Quantity tag for all the prescriptions issued by 'Ally Scripts'.

*/

select *,
case 
	when totalQuantity <20 then 'Low Quantity'
    when totalQuantity between 20 and 49 then 'Medium Quantity'
    else 'High Quantity'
end as Tag
from (
	select pre.prescriptionID, sum(c.quantity) as totalQuantity
	from pharmacy ph inner join prescription pre
	on ph.pharmacyID = pre.pharmacyID
	inner join contain c
	on pre.prescriptionID = c.prescriptionID
	where ph.pharmacyName = 'Ally Scripts'
	group by pre.prescriptionID
) a;

/*
3.)

In the Inventory of a pharmacy 'Spot Rx' the quantity of medicine is considered ‘HIGH QUANTITY’ when the quantity exceeds 7500
 and ‘LOW QUANTITY’ when the quantity falls short of 1000. The discount is considered “HIGH” if the discount rate on a product is 30% or higher, 
 and the discount is considered “NONE” when the discount rate on a product is 0%.
 'Spot Rx' needs to find all the Low quantity products with high discounts and all the high-quantity products with no discount 
 so they can adjust the discount rate according to the demand. 
Write a query for the pharmacy listing all the necessary details relevant to the given requirement.

Hint: Inventory is reflected in the Keep table.

 */
 
 
 select *
 from (select k.medicineID,quantity,discount,
 case 
	when quantity > 7500 then 'HIGH QUANTITY'
    when quantity < 1000 then 'LOW QUANTITY'
end as quantity_tag,
case 
	when discount >= 30 then 'Higher'
    when discount = 0 then 'None'
end as discount_tag
    from 
 pharmacy ph inner join 
 keep k on ph.pharmacyID = k.pharmacyID
 where ph.pharmacyName = 'Spot Rx') a 
 where (quantity_tag = 'HIGH QUANTITY' and discount_tag= 'None') or (quantity_tag = 'LOW QUANTITY' and discount_tag = 'Higher');
 
 
 
 /*
 4.)
 Mack, From HealthDirect Pharmacy, wants to get a list of all the affordable and costly, hospital-exclusive medicines in the database. 
 Where affordable medicines are the medicines that have a maximum price of less than 50% of the avg maximum price of all the medicines in the database, 
 and costly medicines are the medicines that have a maximum price of more than double the avg maximum price of all the medicines in the database.  
 Mack wants clear text next to each medicine name to be displayed that identifies the medicine as affordable or costly. 
 The medicines that do not fall under either of the two categories need not be displayed.
Write a SQL query for Mack for this requirement.

 */
 
 select distinct medicineID,productName, cost_range
 from (
	 select m.medicineID, productName,
	 case 
		when maxPrice < (select avg(maxPrice) *0.5 from medicine) then 'affordable'
		when maxPrice > (select avg(maxPrice) * 2 from medicine) then 'costly'
	end as cost_range
	from pharmacy ph
	 inner join keep k
	 on ph.pharmacyID = k.pharmacyID
	inner join medicine m
	on k.medicineID = m.medicineID
	where m.hospitalExclusive = 'S') a
    where cost_range is not null;
    
/*
5.)
The healthcare department wants to categorize the patients into the following category.
YoungMale: Born on or after 1st Jan  2005  and gender male.
YoungFemale: Born on or after 1st Jan  2005  and gender female.
AdultMale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender male.
AdultFemale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender female.
MidAgeMale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender male.
MidAgeFemale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender female.
ElderMale: Born before 1st Jan 1970, and gender male.
ElderFemale: Born before 1st Jan 1970, and gender female.

Write a SQL query to list all the patient name, gender, dob, and their category.
 
*/
    
select per.personName,per.gender,pa.dob,
case 
	when pa.dob >= '2005-01-01' and per.gender = 'male' then 'YoungMale'
    when pa.dob > '2005-01-01' and per.gender = 'female' then 'YoungFemale'
    when pa.dob >='1985-01-01' and pa.dob < '2005-01-01' and per.gender = 'male' then 'AdultMale'
    when pa.dob >='1985-01-01' and pa.dob < '2005-01-01' and per.gender = 'female' then 'AdultFemale'
	when pa.dob >='1970-01-01' and pa.dob < '1985-01-01' and per.gender = 'male' then 'MidAgeMale'
    when pa.dob >='1970-01-01' and pa.dob < '1985-01-01' and per.gender = 'female' then 'MidAgeFemale'
    when pa.dob < '1970-01-01' and per.gender = 'female' then 'ElderFemale'
    when pa.dob < '1970-01-01' and per.gender = 'male' then 'ElderMale'
end as category
from person per inner join patient pa
on per.personID = pa.patientID;


 
 











    