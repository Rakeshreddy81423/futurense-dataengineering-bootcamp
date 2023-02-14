use healthcare;

/*
Brian, the healthcare department, has requested for a report that shows for each state how many people underwent treatment for the disease “Autism”.  
He expects the report to show the data for each state as well as each gender and for each state and gender combination. 
Prepare a report for Brian for his requirement.
 
*/

select ad.state,coalesce(p.gender,'Both'),count(t.patientID) as patient_count
from address ad inner join person p
on ad.addressID = p.addressID
inner join treatment t
on p.personID = t.patientID
inner join disease d
on t.diseaseID = d.diseaseID
where diseaseName = 'Autism'
group by ad.state, p.gender with rollup;


/*
	Insurance companies want to evaluate the performance of different insurance plans they offer. 
Generate a report that shows each insurance plan, the company that issues the plan, 
and the number of treatments the plan was claimed for. The report would be more relevant if the data compares the 
performance for different years(2020, 2021 and 2022) and if the report also includes the total number of claims in the different years,
 as well as the total number of claims for each plan in all 3 years combined.

 */
 
select ic.companyName,coalesce(ip.planName,'Total of three years'),
sum(case when year(t.date) = 2020 then 1 else 0 end) as '2020',
sum(case when year(t.date) = 2021 then 1 else 0 end) as '2021',
sum(case when year(t.date) = 2022 then 1 else 0 end) as '2022'
 from insurancecompany ic
 inner join insuranceplan ip
 on ic.companyID = ip.companyID
 inner join claim c
 on ip.uin = c.uin
 inner join treatment t 
 on c.claimID = t.claimID
 where year(t.date) in (2020,2021,2022)
 group by ic.companyName,ip.planName with rollup;
 
 
 /*
	Sarah, from the healthcare department, is trying to understand if some diseases are spreading in a particular region. 
    Assist Sarah by creating a report which shows each state the number of the most and least treated diseases by the patients of that state in the year 2022. 
    It would be helpful for Sarah if the aggregation for the different combinations is found as well. Assist Sarah to create this report. 
 */
 
 with cte as(
 select ad.state,t.diseaseID, count(t.treatmentID) as treat_count
 from address ad inner join person p
 on ad.addressID = p.addressID
 inner join treatment t
 on p.personID = t.patientID
 where year(t.date) = 2022
 group by ad.state,t.diseaseID 
 ),
 cte_2 as
 ( select *, dense_rank() over(partition  by state order by treat_count desc) as dn_desc,
	dense_rank() over(partition  by state order by treat_count ) as dn_asc from cte
 )
 select state,diseaseID,treat_count from cte_2 where dn_desc = 1
 union
 select state,diseaseID,treat_count from cte_2 where dn_asc = 1
 order by state;
 
 /*
 Jackson has requested a detailed pharmacy report that shows each pharmacy name,
 and how many prescriptions they have prescribed for each disease in the year 2022, 
 along with this Jackson also needs to view how many prescriptions were prescribed by each pharmacy, 
 and the total number prescriptions were prescribed for each disease.
Assist Jackson to create this report. 
 */
 
 select  ph.pharmacyName,t.diseaseID, count(pre.prescriptionID) as pre_count
 from (select * from treatment where year(date) = 2022) t 
 inner join prescription pre
 on t.treatmentID = pre.treatmentID
 inner join pharmacy ph
 on pre.pharmacyID = ph.pharmacyID
 group by ph.pharmacyID,t.diseaseID;
 
 /*
 Praveen has requested for a report that finds for every disease how many males and females underwent treatment for each in the year 2022.
 It would be helpful for Praveen if the aggregation for the different combinations is found as well.
Assist Praveen to create this report. 
 */
 
select t.diseaseID,
sum(case 
	when p.gender = 'male' then 1 else 0
end )as male_count,
sum(case 
	when p.gender = 'female' then 1 else 0
end ) as female_count
from (select personID,gender from person) p
inner join (select treatmentID,patientID,diseaseID from treatment where year(date) = 2022) t
on p.personID = t.patientID
group by t.diseaseID;


