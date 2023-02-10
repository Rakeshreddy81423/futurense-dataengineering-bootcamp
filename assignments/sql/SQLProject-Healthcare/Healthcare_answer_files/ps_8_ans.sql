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
drop table if exists T1;
drop table if exists T2;
drop table if exists T3;

select Address.city, count(Pharmacy.pharmacyID) as numPharmacy
into T1
from Pharmacy right join Address on Pharmacy.addressID = Address.addressID
group by city
order by count(Pharmacy.pharmacyID) desc;

select Address.city, count(InsuranceCompany.companyID) as numInsuranceCompany
into T2
from InsuranceCompany right join Address on InsuranceCompany.addressID = Address.addressID
group by city
order by count(InsuranceCompany.companyID) desc;

select Address.city, count(Person.personID) as numRegisteredPeople
into T3
from Person right join Address on Person.addressID = Address.addressID
group by city
order by count(Person.personID) desc;

select T1.city, T3.numRegisteredPeople, T2.numInsuranceCompany, T1.numPharmacy
from T1, T2, T3
where T1.city = T2.city and T2.city = T3.city
order by numRegisteredPeople desc;

