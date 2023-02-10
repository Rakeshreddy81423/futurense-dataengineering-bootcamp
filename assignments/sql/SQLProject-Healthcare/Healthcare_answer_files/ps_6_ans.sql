use healthcare;

/*
The healthcare department wants a pharmacy report on the percentage of hospital-exclusive medicine prescribed in the year 2022.
Assist the healthcare department to view for each pharmacy, the pharmacy id, pharmacy name, total quantity of medicine prescribed in 2022,
total quantity of hospital-exclusive medicine prescribed by the pharmacy in 2022, and the percentage of hospital-exclusive medicine to the total medicine prescribed in 2022.
Order the result in descending order of the percentage found. 

*/
select *,hospEx_medicine_count / total_medicine * 100 as percentage from(
	select ph.pharmacyID,ph.pharmacyName,sum( case when m.hospitalExclusive = 'S' then c.quantity else 0 end) as hospEx_medicine_count,
    sum(c.quantity) as total_medicine
	from treatment t
	inner join prescription pre on t.treatmentID = pre.treatmentID
	inner join contain c on pre.prescriptionID = c.prescriptionID
	inner join medicine m on c.medicineID  = m.medicineID
	inner join keep k on m.medicineID = k.medicineID
	inner join pharmacy ph on k.pharmacyID = ph.pharmacyID
	where year(t.date) = 2022
	group by ph.pharmacyID,ph.pharmacyName
) a
order by percentage desc;


/*
	Sarah, from the healthcare department, has noticed many people do not claim insurance for their treatment. 
    She has requested a state-wise report of the percentage of treatments that took place without claiming insurance. 
    Assist Sarah by creating a report as per her requirement.
*/

select ad.state, count(c.claimID) claim_count,count(t.treatmentID) treatment_count,count(c.claimID)/count(t.treatmentID) *100 as treatment_claim_ratio
from address ad inner join person per
on ad.addressID = per.addressID
inner join treatment t
on t.patientID = per.personID
left join claim c
on t.claimID = c.claimID
group by ad.state;


/* 
Sarah, from the healthcare department, is trying to understand if some diseases are spreading in a particular region. 
Assist Sarah by creating a report which shows for each state, 
the number of the most and least treated diseases by the patients of that state in the year 2022. 

*/

with cte1 as
(
	select ad.state,t.diseaseID, count(t.treatmentID) as treat_count
	from address ad inner join person p
	on ad.addressID = p.addressID
	inner join treatment t
	on p.personID = t.patientID
	where year(t.date) = 2022
	group by ad.state,t.diseaseID
),
cte2 as 
(
	select *,dense_rank() over(partition by state order by treat_count desc) as dn
    from cte1
),
cte3 as
(
	select *,min(dn) over(partition by state) as min, max(dn) over(partition by state) as max
from cte2
)
select state,diseaseID,treat_count,dn from cte2 c1
where (state,dn) in (select state,min from cte3 c2 where c1.state = c2.state and c1.dn = c2.dn)
union 
select state,diseaseID,treat_count,dn from cte2 c1
where (state,dn) in (select state,max from cte3 c2 where c1.state = c2.state and c1.dn = c2.dn)
order by state;

/*
Manish, from the healthcare department, wants to know how many registered people are registered as patients as well, in each city. 
Generate a report that shows each city that has 10 or more registered people belonging to it and the number of patients from that 
city as well as the percentage of the patient with respect to the registered people 
*/

select ad.city, count(pe.personID) as person_count, count(pa.patientID) as patient_count, count(pa.patientID)/count(pe.personID) as patient_person_ratio
from address ad inner join person pe
on ad.addressID = pe.addressID
left join patient pa
on pe.personID = pa.patientID
group by ad.city
having count(pe.personID) >= 10;


/*
	It is suspected by healthcare research department that the substance “ranitidine” might be causing some side effects. 
    Find the top 3 companies using the substance in their medicine so that they can be informed about it.
 */
 
 select companyName, count(medicineID) as ranitidina_count
 from medicine
 where substanceName like '%ranitidina%'
 group by companyName
 order by ranitidina_count desc
 limit 3;
 



