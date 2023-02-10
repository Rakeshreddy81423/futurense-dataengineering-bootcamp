use healthcare;

/*
	Some complaints have been lodged by patients that they have been prescribed hospital-exclusive medicine that they can’t find elsewhere and facing problems due to that.
    Joshua, from the pharmacy management, wants to get a report of which pharmacies have prescribed hospital-exclusive medicines the most in the years 2021 and 2022. 
    Assist Joshua to generate the report so that the pharmacies who prescribe hospital-exclusive medicine more often are advised to avoid such practice if possible
 */
 
 
 with cte as
 (
	 select year(t.date) as year,pr.pharmacyID,count(m.hospitalExclusive) as hospEx_count
	 from treatment t inner join prescription pr
	 on t.treatmentID = pr.treatmentID
	 inner join contain c
	 on pr.prescriptionID = c.prescriptionID
	 inner join medicine m
	 on c.medicineID = m.medicineID
	 where year(t.date) in (2021,2022) and hospitalExclusive <> 'N'
	 group by year(t.date),pr.pharmacyID
	 
 )
 select * from cte c1 where hospEx_count in (select max(hospEx_count) from cte c2 where c1.year= c2.year);
 
 
/*
Insurance companies want to assess the performance of their insurance plans. 
Generate a report that shows each insurance plan, the company that issues the plan, and the number of treatments the plan was claimed for. 
*/

 select  ic.companyName,ip.planName,count(t.treatmentID) as treat_count from
 insurancecompany ic inner join insuranceplan ip
 on ic.companyID =ip.companyID
 inner join claim c
 on ip.uin = c.uin
 inner join treatment t
 on c.claimID = t.claimID
 group by ic.companyName,ip.planName 
 order by ic.companyName;
 
 
 /*
	Insurance companies want to assess the performance of their insurance plans.
    Generate a report that shows each insurance company's name with their most and least claimed insurance plans.
 */
 
 with cte as
 (
	 select  ic.companyName,ip.planName, count(c.claimID) claim_count 
	 from
	 insurancecompany ic inner join insuranceplan ip
	 on ic.companyID =ip.companyID
	 inner join claim c
	 on ip.uin = c.uin
	 group by ic.companyName,ip.planName
	 order by ic.companyName
	
),
cte2 as 
(
	select companyName,min(claim_count) as min_count,max(claim_count) as max_count
	from cte group by companyName
)
select companyName,
case
	when claim_count =  (select max_count from cte2 where c1.companyName = cte2.companyName) then planName
end as most,
 case 
	when claim_count  = (select min_count from cte2 where c1.companyName = cte2.companyName) then planName
end as least
from cte c1;



/*
:  The healthcare department wants a state-wise health report to assess which state requires more attention in the healthcare sector.
 Generate a report for them that shows the state name, number of registered people in the state, number of registered patients in the state, and the people-to-patient ratio.
 sort the data by people-to-patient ratio
 */
 select state, count(pe.personID) as person_count, count(pa.patientID) patient_count,
 count(pe.personID)/count(pa.patientID) as ratio
 from address ad left join person pe
 on ad.addressID = pe.addressID
 left join patient pa
 on pe.personID = pa.patientID
 group by state
 order by ratio desc;
 
 
 /*
 Jhonny, from the finance department of Arizona(AZ), has requested a report that lists the total quantity of medicine each pharmacy 
 in his state has prescribed that falls under Tax criteria I for treatments that took place in 2021. Assist Jhonny in generating the report. 
 
 */
 select ph.pharmacyID, sum(k.quantity) as total_quantity
 from address ad inner join pharmacy ph
 on ad.addressID = ph.addressID
 inner join keep k
 on ph.pharmacyID = k.pharmacyID
 inner join medicine m 
 on k.medicineID = m.medicineID
 inner join contain c 
 on m.medicineID = c.medicineID
 inner join prescription pre
 on c.prescriptionID = pre.prescriptionID
 inner join treatment t
 on pre.treatmentID = t.treatmentID
 where ad.state = 'AZ' 
 and year(t.date) = 2021 and m.taxCriteria = 'I'
 group by ph.pharmacyID;
 
 
--  select p.pharmacyID,sum(k.quantity) from pharmacy p natural join keep k
--  where p.pharmacyID = 1478
--  group by p.pharmacyID;
