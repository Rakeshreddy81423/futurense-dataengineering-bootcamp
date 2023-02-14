use healthcare;

/*
	The healthcare department has requested a system to analyze the performance of insurance companies and their plan.
For this purpose, create a stored procedure that returns the performance of different insurance plans of an insurance company.
When passed the insurance company ID the procedure should generate and return all the insurance plan names the provided company issues,
the number of treatments the plan was claimed for, and the name of the disease the plan was claimed for the most. 
The plans which are claimed more are expected to appear above the plans that are claimed less.

*/

delimiter //
create procedure sp_ps10_insurancePlanDetails(compID int)
begin
	with cte as
	(
			select ip.companyID,planName,t.diseaseID,d.diseaseName,t.claimID
			from 
			(select * from insuranceplan where companyID = compID) ip
			inner join claim c on ip.uin = c.uin
			inner join (select treatmentID, diseaseID, claimID from treatment) t
			on c.claimID = t.claimID
			inner join disease d on t.diseaseID = d.diseaseID
	),
	cte_1 as 
	(
	select companyID,planName,count(claimID) as claim_count from cte group by companyID,planName
	),
	cte_2 as 
	(
		select companyID,planName,diseaseID, count(claimID)  per_disease_claim_count 
		from cte group by companyID,planName,diseaseID
	),
	cte_3 as
	(
		select companyID,planName,max(per_disease_claim_count) as max_claims from cte_2 group by companyID,planName
	),
	cte_4 as
	(
		select  c3.companyID,c3.planName,max_claims,diseaseID from
		cte_3 c3 join cte_2 c2 on c3.companyID = c2.companyID and c3.planName = c2.planName and c3.max_claims = c2.per_disease_claim_count
	)
	select cte_1.companyID,cte_1.planName,claim_count,max_claims,diseaseID from cte_1 join cte_4 on cte_1.companyID = cte_4.companyID and cte_1.planName =cte_4.planName;
end//
delimiter ;
drop  procedure sp_ps10_insurancePlanDetails;

call sp_ps10_insurancePlanDetails(1583);



/*
It was reported by some unverified sources that some pharmacies are more popular for certain diseases.
 The healthcare department wants to check the validity of this report.
Create a stored procedure that takes a disease name as a parameter and would return the top 3 pharmacies the patients are preferring for the treatment of that disease in 2021 as well as for 2022.
Check if there are common pharmacies in the top 3 list for a disease, in the years 2021 and the year 2022.
Call the stored procedure by passing the values “Asthma” and “Psoriasis” as disease names and draw a conclusion from the result.

 */
 
 delimiter //
 create procedure sp_ps10_topPharmacies(dName varchar(100))
begin
	with cte_1 as
    (
		select pre.pharmacyID,
		sum(case when year(t.date) = 2021 then 1 else 0 end ) as year_2021,
		sum(case when year(t.date) = 2022 then 1 else 0 end ) as year_2022
		from (select * from disease where diseaseName = dName) d
		inner join (select * from treatment where year(date) in (2021,2022)) t
		on d.diseaseID = t.diseaseID
		inner join prescription pre on t.treatmentID  = pre.treatmentID
		group by pre.pharmacyID
    )
	(select * from cte_1 order by year_2021 desc limit 3) union (select * from cte_1 order by year_2022 desc limit 3) ;
end//
delimiter ;

drop procedure sp_ps10_topPharmacies;
call sp_ps10_topPharmacies('Asthma');

call sp_ps10_topPharmacies('Psoriasis');

/*
Jacob, as a business strategist, wants to figure out if a state is appropriate for setting up an insurance company or not.
Write a stored procedure that finds the num_patients, num_insurance_companies, and insurance_patient_ratio, 
the stored procedure should also find the avg_insurance_patient_ratio and if the insurance_patient_ratio of the given state is less than 
the avg_insurance_patient_ratio then it Recommendation section can have the value “Recommended” otherwise the value can be “Not Recommended”.

Description of the terms used:
num_patients: number of registered patients in the given state
num_insurance_companies:  The number of registered insurance companies in the given state
insurance_patient_ratio: The ratio of registered patients and the number of insurance companies in the given state
avg_insurance_patient_ratio: The average of the ratio of registered patients and the number of insurance for all the states.

 */


delimiter //
create procedure sp_ps10_insuranceCompanyPatientRatio( state_name varchar(20))
begin
	with cte_1 as
	(
		select state,count(companyID) as comp_count from 
		address ad 
		inner join insuranceCompany ic on ad.addressID = ic.addressID
		group by state
	),
	cte_2 as
	(
		select state, count(p.personID) as pat_count from 
		address  ad
		inner join person p on ad.addressID = p.addressID
		group by state
	),
	cte_3 as
	(
		select *, cte_2.pat_count / cte_1.comp_count as  insurance_patient_ratio from cte_1  natural join cte_2
	)
	select *,if(insurance_patient_ratio < (select avg(insurance_patient_ratio) from cte_3) ,'Recommended','Not Recommended') as Recommendation
	from cte_3 where state = state_name;
end //
delimiter ;

drop  procedure sp_ps10_insuranceCompanyPatientRatio;
call sp_ps10_insuranceCompanyPatientRatio('AK');

/*
	Currently, the data from every state is not in the database, The management has decided to add the data from other states and cities as well. 
    
It is felt by the management that it would be helpful if the date and time were to be stored whenever new city or state data is inserted.
The management has sent a requirement to create a PlacesAdded table if it doesn’t already exist, that has four attributes. placeID, placeName, placeType, and timeAdded.

Description
placeID: This is the primary key, it should be auto-incremented starting from 1
placeName: This is the name of the place which is added for the first time
placeType: This is the type of place that is added for the first time. The value can either be ‘city’ or ‘state’
timeAdded: This is the date and time when the new place is added
You have been given the responsibility to create a system that satisfies the requirements of the management. Whenever some data is inserted in the Address table that has a new city or state name, the PlacesAdded table should be updated with relevant data. 

*/


create table if not exists PlacesAdded
(
	placeID int not null,
    placeName varchar(100),
    placeType enum('city','state') not null,
    timeAdded  datetime default now()
);

 -- drop table PlacesAdded;
alter table PlacesAdded add constraint `PK_placesaddred` primary key(placeID);
alter table PlacesAdded modify column placeID int auto_increment;

delimiter //
create trigger after_new_state_city_insert
before insert
on address for each row
begin
	declare check_state varchar(20);
    declare check_city varchar(100);
    
    select distinct state into check_state from address where state = new.state;
    select distinct city into check_city from address where city = new.city;
    if check_state is null
    then
		insert into PlacesAdded(placeName,placeType) values (new.state,'state');
	elseif check_city is null then
		insert into PlacesAdded(placeName,PlaceType) values(new.city,'city');
	
    end if;
end//
delimiter ;


select * from address order by addressID desc;
insert into address values(999549,'1-26 oogle','Nellore','TE',524285);

select * from placesadded;




/*
	Some pharmacies suspect there is some discrepancy in their inventory management. The quantity in the ‘Keep’ is updated regularly and there is no record of it. 
    They have requested to create a system that keeps track of all the transactions whenever the quantity of the inventory is updated.
You have been given the responsibility to create a system that automatically updates a Keep_Log table which has  the following fields:
id: It is a unique field that starts with 1 and increments by 1 for each new entry
medicineID: It is the medicineID of the medicine for which the quantity is updated.
quantity: The quantity of medicine which is to be added. If the quantity is reduced then the number can be negative.
For example:  If in Keep the old quantity was 700 and the new quantity to be updated is 1000, then in Keep_Log the quantity should be 300.
Example 2: If in Keep the old quantity was 700 and the new quantity to be updated is 100, then in Keep_Log the quantity should be -600.

 */
 
create table if not exists keep_log
(
	id int not null unique,
    medicineID int,
    quantity int
);

alter table  keep_log modify column id int auto_increment;

delimiter //

create trigger after_update_medicine_quantity
before update
on keep for each row
begin
	declare new_quantity int;
    set new_quantity = new.quantity - old.quantity;
	insert into keep_log(medicineID,quantity) values(new.medicineID,new_quantity);
end//

delimiter ;

select * from keep limit 100;

update  keep set quantity = 6078 where medicineID = 3498;

select * from keep_log;




