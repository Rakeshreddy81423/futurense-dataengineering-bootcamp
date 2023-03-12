use healthcare;

--   Jimmy, from the healthcare department, has requested a report that shows how the number of treatments each age category of patients has gone through in the year 2022. 
-- The age category is as follows, Children (00-14 years), Youth (15-24 years), Adults (25-64 years), and Seniors (65 years and over).
-- Assist Jimmy in generating the report.

select 
sum(case
	when timestampdiff(year,p.dob,t.date) between 0 and 14 then 1 else 0
end) as children,
sum(case
	when timestampdiff(year,p.dob,t.date) between 15 and 24 then 1 else 0
end) as youth,
sum(case
	when timestampdiff(year,p.dob,t.date) between 25 and 64 then 1 else 0
end) as adults,
sum(case
	when timestampdiff(year,p.dob,t.date) >=65 then 1 else 0
end) as seniors

 from 
patient p inner join treatment t 
on p.patientID=t.patientID
where year(t.date) = '2022';

-- Jimmy, from the healthcare department, wants to know which disease is infecting people of which gender more often.
-- Assist Jimmy with this purpose by generating a report that shows for each disease the male-to-female ratio. Sort the data in a way that is helpful for Jimmy.

select *, round((male/female),2) as m_f_ratio from
(
	select d.diseaseName,
	sum(case
		when gender = 'male' then 1 else 0 end
		) as male,
	sum(case
		when gender = 'female' then 1 else 0 end
		) as female
	from person p inner join treatment t
	on p.personid = t.patientid
	inner join disease d
	on t.diseaseID = d.diseaseID
	group by d.diseaseName
) a;

/* Jacob, from insurance management, has noticed that insurance claims are not made for all the treatments. 
 He also wants to figure out if the gender of the patient has any impact on the insurance claim. 
 Assist Jacob in this situation by generating a report that finds for each gender the number of treatments, number of claims, and treatment-to-claim ratio. 
And notice if there is a significant difference between the treatment-to-claim ratio of male and female patients. 
*/


select *, round(total_treatments/ total_claims, 2) as ratio from 
(
	select p.gender, count(t.treatmentID) as total_treatments,
	count(c.claimID) as total_claims from
	person p inner join treatment t
	on p.personID = t.patientID
	left join claim c
	on t.claimID = c.claimID
	group by p.gender
)a;

/*
	The Healthcare department wants a report about the inventory of pharmacies. 
    Generate a report on their behalf that shows how many units of medicine each pharmacy has in their inventory, the total maximum retail price of those medicines, 
    and the total price of all the medicines after discount. 
Note: discount field in keep signifies the percentage of discount on the maximum price.

*/

select p.pharmacyID , sum(k.medicineID * k.quantity) as total_medicine,
sum(k.medicineID * k.quantity * m.maxPrice) as total_max_retail_price,
sum(k.medicineID * k.quantity * m.maxPrice * (100-k.discount)/100) as price_after_discount
from pharmacy p inner join keep k
using(pharmacyID) inner join medicine m
using(medicineID)
group by pharmacyID;


/*
	The healthcare department suspects that some pharmacies prescribe more medicines than others in a single prescription, for them, 
    generate a report that finds for each pharmacy the maximum, minimum and average number of medicines prescribed in their prescriptions. 
*/
select p.pharmacyID,max(c.quantity) as max, min(c.quantity) as min, avg(c.quantity) as average
from 
prescription p inner join contain c
using(prescriptionID)
group by p.pharmacyID;



