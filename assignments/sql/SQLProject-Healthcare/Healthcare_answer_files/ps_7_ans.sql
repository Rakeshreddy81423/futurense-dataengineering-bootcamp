use healthcare;

/*
	Insurance companies want to know if a disease is claimed higher or lower than average. 
    Write a stored procedure that returns “claimed higher than average” or “claimed lower than average” when the diseaseID is passed to it. 
Hint: Find average number of insurance claims for all the diseases.  
If the number of claims for the passed disease is higher than the average return “claimed higher than average” otherwise “claimed lower than average”.

 */
 
 delimiter //
 create procedure sp_checkDiseaseClaim ( in dID int, out message varchar(50))
 begin
	declare avg_claim float;
    declare claim_count int;
    
	select count(claimID)/count(distinct diseaseID) into avg_claim from treatment;
    
    select count(claimID) into claim_count
    from treatment where diseaseID = dID;
    
    select if(claim_count > avg_claim ,'claimed higher than average','claimed lower than average') into message;
--     if claim_count > avg_claim
-- 		then set message = 'claimed higher than average';
-- 	else 
-- 		set message = 'claimed lower than average';
-- 	end if;
 end //
 
 delimiter ;
 
 -- drop procedure sp_checkDiseaseClaim;
call sp_checkDiseaseClaim(10,@message);
select @message as message;

/*
Joseph from Healthcare department has requested for an application which helps him get genderwise report for any disease. 
Write a stored procedure when passed a disease_id returns 4 columns,
disease_name, number_of_male_treated, number_of_female_treated, more_treated_gender
Where, more_treated_gender is either ‘male’ or ‘female’ based on which gender underwent more often for the disease,
 if the number is same for both the genders, the value should be ‘same’.
 */
 
 delimiter //
create procedure sp_genderwiseReport(dID int)
begin
	select *,
    case
		when a.number_of_male_treated > a.number_of_female_treated then 'male'
        when a.number_of_male_treated < a.number_of_female_treated then 'female'
        else 'same'
	end as more_treated_gender from (
		select d.diseaseName,
		sum(case when p.gender = 'male' then 1 else 0
		end ) as  number_of_male_treated,
		sum(case when p.gender = 'female' then 1 else 0
		end ) as number_of_female_treated
		from  person p inner join treatment t
		on p.personID = t.patientID
		inner join disease d
		on t.diseaseID = d.diseaseID
		where d.diseaseID = dID
		group by diseaseName
    ) a;
end//
delimiter ;

drop  procedure sp_genderwiseReport;
call sp_genderwiseReport(40);


/*
	The insurance companies want a report on the claims of different insurance plans. 
Write a query that finds the top 3 most and top 3 least claimed insurance plans.
The query is expected to return the insurance plan name,
the insurance company name which has that plan, and whether the plan is the most claimed or least claimed. 
*/

with cte as 
(
	select ic.companyName,ip.planName,count(c.claimID ) as claim_count
	from claim c inner join insuranceplan ip
	on c.uin = ip.uin
	inner join insurancecompany ic
	on ip.companyID = ic.companyID
	group by ic.companyName,ip.planName
	
),
cte_2 as (select *,'most claimed' as status from cte order by claim_count desc limit 3),
cte_3 as (select * , 'lease claimed' as status from cte order by claim_count limit 3)
select * from cte_2 union select * from cte_3;

/*
	The healthcare department wants to know which category of patients is being affected the most by each disease.
Assist the department in creating a report regarding this.
Provided the healthcare department has categorized the patients into the following category.
YoungMale: Born on or after 1st Jan  2005  and gender male.
YoungFemale: Born on or after 1st Jan  2005  and gender female.
AdultMale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender male.
AdultFemale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender female.
MidAgeMale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender male.
MidAgeFemale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender female.
ElderMale: Born before 1st Jan 1970, and gender male.
ElderFemale: Born before 1st Jan 1970, and gender female.
 */

	select t.diseaseID,
	sum(case 
		when pa.dob >= '2005-01-01' and per.gender = 'male' then 1 else 0
	end ) as 'YoungMale',
	sum(case
		when pa.dob > '2005-01-01' and per.gender = 'female' then 1 else 0
	end ) as 'YoungFemale',
	sum(case 
		when pa.dob >='1985-01-01' and pa.dob < '2005-01-01' and per.gender = 'male' then 1 else 0
	end ) as 'AdultMale',
	sum(case
		when pa.dob >='1985-01-01' and pa.dob < '2005-01-01' and per.gender = 'female' then 1 else 0
	end) as 'AdultFemale',
	sum(case 
		when pa.dob >='1970-01-01' and pa.dob < '1985-01-01' and per.gender = 'male' then 1 else 0 
	end) as 'MidAgeMale',
	sum(case 
		when pa.dob >='1970-01-01' and pa.dob < '1985-01-01' and per.gender = 'female' then 1 else 0
	end) as 'MidAgeFemale',
	sum(case 
		when pa.dob < '1970-01-01' and per.gender = 'female' then 1 else 0
	end )as 'ElderFemale',
	sum(case
		when pa.dob < '1970-01-01' and per.gender = 'male' then 1 else 0
	end) as 'ElderMale'
	from person per inner join patient pa
	on per.personID = pa.patientID
	inner join treatment t
	on pa.patientID = t.patientID
	group by t.diseaseID;
    

/*
	Anna wants a report on the pricing of the medicine. She wants a list of the most expensive and most affordable medicines only. 
Assist anna by creating a report of all the medicines which are pricey and affordable, listing the companyName, productName, description, maxPrice, 
and the price category of each. Sort the list in descending order of the maxPrice.
Note: A medicine is considered to be “pricey” if the max price exceeds 1000 and “affordable” if the price is under 5. Write a query to find 
 */
 
 select companyName, productName,description, maxPrice, 
 case 
	when maxPrice> 1000 then 'pricey'
    when maxPrice < 5 then 'affordable'
end as category
from medicine
where maxPrice > 1000 or maxPrice < 5
order by maxPrice desc;



