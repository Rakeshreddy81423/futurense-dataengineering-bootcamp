use healthcare;

/*
	A company needs to set up 3 new pharmacies, they have come up with an idea that the pharmacy can be set up in cities where the pharmacy-to-prescription 
    ratio is the lowest and the number of prescriptions should exceed 100.
    Assist the company to identify those cities where the pharmacy can be set up.
*/
select city,count(pharmacyID) / sum(pre_count) as ratio
from
(
	select city,pharmacyID,count(prescriptionID) as pre_count
	from
	address ad inner join pharmacy ph 
	on ad.addressID = ph.addressID
	inner join prescription pr using(pharmacyID)
	group by city, pharmacyID
) a
group by city
having sum(pre_count)>100
order by ratio;


/*
	The State of Alabama (AL) is trying to manage its healthcare resources more efficiently.
    For each city in their state, they need to identify the disease for which the maximum number of patients have gone for treatment.
    Assist the state for this purpose.
Note: The state of Alabama is represented as AL in Address Table.

*/


with cte as
(
	select city,d.diseaseName, count(patientID) as pat_count
	from address ad inner join person p
	on ad.addressID = p.addressID
	inner join treatment t 
	on personID = t.patientID
	inner join disease d
	on t.diseaseID = d.diseaseID
	where state = 'AL'
	group by city,diseaseName
),
cte2 as
(
select  city,diseaseName,pat_count, dense_rank() over(partition by city order by pat_count desc) as dn from cte
)
select city,diseaseName,pat_count from cte2 where dn = 1;


/*
	The healthcare department needs a report about insurance plans. 
    The report is required to include the insurance plan, which was claimed the most and least for each disease.  
    Assist to create such a report.
*/

with cte as
	(select  t.diseaseID, planName,count(planName) as plan_count from claim c 
	inner join insuranceplan ip
	on ip.uin = c.uin
	inner join treatment t
	on c.claimID = t.claimID
	group by t.diseaseID,planName
),
cte2 as
(
	select *, dense_rank() over(partition by diseaseID order by plan_count desc) as dn_1
	from cte
)
-- select a.diseaseID,most,least from
-- (select diseaseID,planName as least from cte2 c1 where (diseaseID,dn_1) = (select diseaseID,min(dn_1) from cte2  c2 where c1.diseaseID = c2.diseaseID)) a
-- inner join (select diseaseID,planName as most from cte2 c1 where (diseaseID,dn_1) = (select diseaseID,max(dn_1) from cte2  c2 where c1.diseaseID = c2.diseaseID)) b
-- on a.diseaseID = b.diseaseID;

-- select * from cte2 c1 where dn_1 = (select min(dn_1) from cte2  c2 where c1.diseaseID = c2.diseaseID) or
-- dn_1 = (select max(dn_1) from cte2 c2 where c1.diseaseID = c2.diseaseID)
-- order by diseaseID;


/*
	The Healthcare department wants to know which disease is most likely to infect multiple people in the same household. 
    For each disease find the number of households that has more than one patient with the same disease. 
    Note: 2 people are considered to be in the same household if they have the same address. 
*/

select  diseaseID,diseaseName,count(address1) as total_households
from
(
select d.diseaseID, d.diseaseName,ad.address1,count(t.patientID) patient_count
from address ad 
inner  join person p
on ad.addressID = p.addressID
inner join treatment t
on p.personID = t.patientID
inner join disease d on
t.diseaseID = d.diseaseID
group by d.diseaseID,ad.address1
having patient_count > 1
) a
group by diseaseID;


/*
	An Insurance company wants a state wise report of the treatments to claim ratio between 1st April 2021 and 31st March 2022 (days both included).
    Assist them to create such a report.
*/
select state,count(treatmentID) as treat_count, count(claimID) as claim_count, count(treatmentID)/count(claimID) as ratio
from address ad inner join person p
on ad.addressID = p.addressID
inner join treatment t
on p.personID = t.patientID
where t.date between '2021-04-01' and '2022-03-31'
group by state;






 



