use healthcare;

/*
Johansson is trying to prepare a report on patients who have gone through treatments more than once.
 Help Johansson prepare a report that shows the patient's name, the number of treatments they have undergone, and their age, 
Sort the data in a way that the patients who have undergone more treatments appear on top.
 */
 

 select p.patientID,per.personName,timestampdiff(year,p.dob,curdate()) as age, count(treatmentID) as treatment_count
 from patient p inner join treatment t
 on p.patientID = t.patientID
 inner join person per
 on p.patientID = per.personID
 group by p.patientID,per.personName
 order by treatment_count desc;
 
 /*
	Bharat is researching the impact of gender on different diseases, 
    He wants to analyze if a certain disease is more likely to infect a certain gender or not.
Help Bharat analyze this by creating a report showing for every disease how many males and females underwent treatment for each in the year 2021. 
It would also be helpful for Bharat if the male-to-female ratio is also shown.

 */
 select *, male_count/female_count as ratio
 from 
 (
	 select t.diseaseID,
	 sum(
		case when per.gender = 'male' then 1 else 0 end 
	 )as male_count,
	  sum(
		case when per.gender = 'female' then 1 else 0 end 
	 )as female_count
	 from person per inner join treatment t
	 on per.personID = t.patientID
	 where year(t.date) = 2021
	 group by t.diseaseID
 ) a;
 
 
 /*
	Kelly, from the Fortis Hospital management, has requested a report that shows for each disease,
    the top 3 cities that had the most number treatment for that disease.
	Generate a report for Kelly’s requirement.
 */
 
 select diseaseID,city,treat_count from 
 (
	 select *, dense_rank() over(partition by diseaseID order by treat_count desc) as dn
	 from 
	 (
		 select t.diseaseID,ad.city,count(treatmentID) as treat_count
		 from 
		 address ad inner join person pe
		 on ad.addressID = pe.addressID
		 inner join treatment t
		 on pe.personID = t.patientID
		 group by t.diseaseID,ad.city
	 )a
) b where dn<=3;

/* 
Brooke is trying to figure out if patients with a particular disease are preferring some pharmacies over others or not, 
For this purpose, she has requested a detailed pharmacy report that shows each pharmacy name, 
and how many prescriptions they have prescribed for each disease in 2021 and 2022, 
She expects the number of prescriptions prescribed in 2021 and 2022 be displayed in two separate columns.
Write a query for Brooke’s requirement.
*/

select ph.pharmacyName,t.diseaseID,
sum(case
	when year(t.date) = 2021 then 1 else 0
end) as '2021',
sum(case
	when year(t.date) = 2022 then 1 else 0
end) as '2022'
from pharmacy ph
inner join prescription pr on ph.pharmacyID = pr.pharmacyID
inner join treatment t on pr.treatmentID = t.treatmentID
where year(t.date) in (2021,2022)
group by ph.pharmacyName,t.diseaseID;


/*
	Walde, from Rock tower insurance, has sent a requirement for a report that presents which insurance company is targeting the patients of which state the most. 
Write a query for Walde that fulfills the requirement of Walde.
Note: We can assume that the insurance company is targeting a region more if the patients of that region are claiming more insurance of that company.

*/

select ad.state,ic.companyName,count(t.claimID) as claim_count
from  insurancecompany ic inner join address ad  on 
ic.addressID =  ad.addressID inner join person p
on ad.addressID = p.addressID
inner join treatment t on
p.personID = t.patientID
inner join claim  c
on t.claimID = c.claimID
group by ad.state,ic.companyName
order by state;