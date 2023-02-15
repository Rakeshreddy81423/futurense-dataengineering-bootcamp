use healthcare;

/*
Patients are complaining that it is often difficult to find some medicines. 
They move from pharmacy to pharmacy to get the required medicine.
 A system is required that finds the pharmacies and their contact number that have the required medicine in their inventory. 
 So that the patients can contact the pharmacy and order the required medicine.
Create a stored procedure that can fix the issue.

 */
 
 delimiter //
create procedure sp_ps_11_findDeatailsOfCompanyBasedOnMedicine(m_name varchar(100))
begin
	SELECT 
    ph.pharmacyName, ph.phone, m.maxPrice
FROM
    (SELECT 
        medicineID, companyName, maxPrice
    FROM
        medicine
    WHERE
        productName = m_name) m
        INNER JOIN
    keep k ON m.medicineID = k.medicineID
        INNER JOIN
    pharmacy ph ON k.pharmacyID = ph.pharmacyID;
end//
delimiter ;

drop procedure sp_ps_11_findDeatailsOfCompanyBasedOnMedicine;
call sp_ps_11_findDeatailsOfCompanyBasedOnMedicine('OSTENAN');

/*
	The pharmacies are trying to estimate the average cost of all the prescribed medicines per prescription, 
    for all the prescriptions they have prescribed in a particular year. 
    Create a stored function that will return the required value when the pharmacyID and year are passed to it.
    Test the function with multiple values.
*/

delimiter //
create function fn_ps_11_getAvgcostOfMedicines(pharmacy_id int, yr int)
returns float
deterministic
begin
	declare avg_cost float;
	   with cte as(
		select pre.prescriptionID,c.medicineID, c.quantity*m.maxPrice each_medicine_cost
		from (select * from prescription where pharmacyID = pharmacy_id) pre 
		inner join (select treatmentID from treatment where year(date) = yr) t
		on pre.treatmentID = t.treatmentID
		inner join contain c on pre.prescriptionID = c.prescriptionID
		inner join (select medicineID,maxPrice from medicine ) m on c.medicineID = m.medicineID
	)
	select avg(total_cost) into avg_cost from 
    (
		select prescriptionID,sum(each_medicine_cost) total_cost
		from cte group by prescriptionID
    ) a;
    
    return (avg_cost);
end //
delimiter ;

SELECT FN_PS_11_GETAVGCOSTOFMEDICINES(1008, 2022) AS avg_cost;

SELECT FN_PS_11_GETAVGCOSTOFMEDICINES(1194, 2021) AS avg_cost;


/*
	The healthcare department has requested an application that finds out the disease that was spread the most in a state for a given year. 
    So that they can use the information to compare the historical data and gain some insight.
Create a stored function that returns the name of the disease for which the patients from a particular state had the most number of treatments for a particular year. 
Provided the name of the state and year is passed to the stored function

 */
 
 delimiter //
 create function fn_ps_11_findStateWithGivenDisease(state_name varchar(20), yr int)
 returns varchar(100)
 deterministic
 begin
	declare disease_name varchar(100);
    select diseaseName into disease_name from 
    (
		select  diseaseName,count(t.treatmentID) as treat_count from 
		(select addressID from address where state = state_name) ad
		inner join (select personID,addressID from person) pe on ad.addressID = pe.addressID
		inner join ( select patientID,treatmentID,diseaseID from treatment where year(date) = yr ) t on pe.personID = t.patientID
		inner join (select diseaseID,diseaseName from disease) d on t.diseaseID = d.diseaseID
		group by d.diseaseName
		order by treat_count desc limit 1
    ) a;
    
    return (disease_name);
    
 end //
 delimiter ;
 
 drop function fn_ps_11_findStateWithGivenDisease;
 
 select fn_ps_11_findStateWithGivenDisease('OK',2022) as diseaseName;
 
 
/*
The representative of the pharma union, Aubrey, has requested a system that she can use to find how 
many people in a specific city have been treated for a specific disease in a specific year.
Create a stored function for this purpose.

 */
 
 delimiter //
 create function fn_ps_11_findCityTreatmentCount(city_name varchar(100), disease_name varchar(100), yr int)
 returns int
 deterministic
 begin
	declare patient_count int;
	select count(t.treatmentID) into patient_count from
    (select addressID from address where city = city_name) ad 
	inner join (select addressID,personID from person) pe on ad.addressID = pe.addressID
	inner join (select patientID,diseaseID,treatmentID from treatment where year(date) = yr) t on pe.personID = t.patientID
	inner join (select diseaseID from disease where diseaseName = disease_name) d on t.diseaseID = d.diseaseID;
    
    return patient_count;
 end//
 delimiter ;
 
 drop function fn_ps_11_findCityTreatmentCount;
 
 select fn_ps_11_findCityTreatmentCount('Edmond','Anxiety disorder',2022) as patient_count;


/*
	The representative of the pharma union, Aubrey, is trying to audit different aspects of the pharmacies. 
    She has requested a system that can be used to find the average balance for claims submitted by a specific insurance company in the year 2022. 
	Create a stored function that can be used in the requested application. 

*/

delimiter //
create function fn_ps_11_findClaimCountOfCompany(comp_name varchar(100))
returns int 
deterministic
begin
	declare claim_count int;
	select count(t.claimID) into claim_count from 
	(select companyId,companyName from insuranceCompany where companyName = comp_name ) ic
	inner join (select companyID,uin from insurancePlan) ip on ic.companyID = ip.companyID
	inner join (select claimID,uin from claim) c on ip.uin = c.uin
	inner join(select claimID from treatment where year(date) = 2022 ) t on c.claimID = t.claimID;

return (claim_count);
end //
delimiter ;


select  fn_ps_11_findClaimCountOfCompany('Niva Bupa Health Insurance Co. Ltd.') claim_count;

select  fn_ps_11_findClaimCountOfCompany('Universal Sompo GIC') claim_count;

