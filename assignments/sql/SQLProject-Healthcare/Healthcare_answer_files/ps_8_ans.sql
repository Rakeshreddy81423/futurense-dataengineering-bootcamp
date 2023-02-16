use healthcare;

/* 
	-- For each age(in years), how many patients have gone for treatment?
*/
SELECT timestampdiff(year, dob , curdate()) AS age, count(Patient.patientID) AS numTreatments
from patient
JOIN Treatment ON Treatment.patientID = Patient.patientID
group by timestampdiff(year, dob , curdate())
order by numTreatments desc;

/* 
	-- For each city, Find the number of registered people, number of pharmacies, and number of insurance companies.
*/

select Address.city, count(Pharmacy.pharmacyID) numPharmacy,
count(InsuranceCompany.companyID) numInsuranceCompany,
count(Person.personID) as numRegisteredPeople
from Address left join Pharmacy on Address.addressID = Pharmacy.addressID
left join InsuranceCompany  on  InsuranceCompany.addressID = Address.addressID
left join Person on Person.addressID = Address.addressID
group by Address.city
order by numRegisteredPeople desc;

/*
-- Total quantity of medicine for each prescription prescribed by Ally Scripts
-- If the total quantity of medicine is less than 20 tag it as "Low Quantity".
-- If the total quantity of medicine is from 20 to 49 (both numbers including) tag it as "Medium Quantity".
-- If the quantity is more than equal to 50 then tag it as "High quantity".

 */
 
 select c.prescriptionID, sum(c.quantity) as totalQuantity,
 case
	when sum(c.quantity) < 20 then 'Low Quantity'
    when sum(c.quantity) between 20 and 49 then 'Medium Quantity'
    else 'High Quantity'
end as Tag
 from contain c  join prescription pre on c.prescriptionID = pre.prescriptionID
 join (select pharmacyID from pharmacy where pharmacyName = 'Ally Scripts') ph
 on pre.pharmacyID = pre.pharmacyID
 group by c.prescriptionID;
 
 
 /*
-- The total quantity of medicine in a prescription is the sum of the quantity of all the medicines in the prescription.
-- Select the prescriptions for which the total quantity of medicine exceeds
-- the avg of the total quantity of medicines for all the prescriptions.

 */ 

with cte as
(
	select Prescription.pharmacyID, Prescription.prescriptionID, sum(quantity) as totalQuantity
	from (select treatmentID from Treatment where year(date) = 2022) Treatment 
	join Prescription on Treatment.treatmentID = Prescription.treatmentID
	join Contain on Contain.prescriptionID = Prescription.prescriptionID
	group by Prescription.pharmacyID, Prescription.prescriptionID
	order by Prescription.pharmacyID, Prescription.prescriptionID
)
select * from cte where totalQuantity > (select avg(totalQuantity) from cte);


/* 
-- Select every disease that has 'p' in its name, and 
-- the number of times an insurance claim was made for each of them. 
*/


select disease.diseaseName, count(claimID) as numClaims
from (select diseaseID,diseaseName from disease where diseaseName like '%p%') disease
join treatment on disease.diseaseID = treatment.diseaseID
group by diseaseName;

 