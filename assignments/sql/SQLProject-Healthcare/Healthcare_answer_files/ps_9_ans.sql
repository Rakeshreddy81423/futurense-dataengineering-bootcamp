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
 
 select ad.state,t.diseaseID, count(t.treatmentID) as treat_count
 from address ad inner join person p
 on ad.addressID = p.addressID
 inner join treatment t
 on p.personID = t.patientID
 where year(t.date) = 2022
 group by ad.state,t.diseaseID;
 