use optimisation;
create table if not exists countries
(
	country_id int(11),
    country_name varchar(20),
    region_id int(11)
);


select * from countries;

alter table countries add constraint `UQ_countryid_regionid` unique(country_id,region_id);

show create table countries;
show indexes from countries;

-- add a primary key constraint
alter table countries add constraint `PK_countries` primary key (country_id);

-- drop primary key constraint
alter table countries drop primary key;




-- Q.2) 
create table if not exists jobs
(
	job_id varchar(10) not null,
    job_title varchar(35) not null default '',
    min_salary decimal(6,0) default 8000,
    max_salary decimal(6,0) default null
);

-- add pk to jobs table
alter table jobs add constraint `PK_jobs` primary key(job_id);

-- Q.3)
create table if not exists job_history
(
	employee_id decimal(6,0) not null unique,
    start_date date,
    end_date date,
    job_id varchar(10) not null,
    department_id decimal(4,0)
);

alter table job_history add constraint `FK_jobhistory_jobs` foreign key(job_id) references jobs(job_id);


-- Q.4)
create table  employees
(
		employee_id decimal(6,0)  not null,
        first_name varchar(20) not null,
        last_name varchar(20),
        email  varchar(20) not null,
        phone_number varchar(20) default null,
        hire_date date not null,
        job_id varchar(10) not null,
        salary decimal(8,2) default null,
        commission decimal(2,2) default null,
        manager_id decimal(6,0) default null,
        department_id decimal(4,0) default null
);

alter table employees add constraint `PK_employees` primary key(employee_id);
alter table employees add constraint `UQ_departmentid_managerid` unique(department_id,manager_id);
alter table employees add constraint `FK_departments_employees` foreign key(department_id,manager_id)
references departments(department_id,manager_id);
show indexes from employees;


-- Q.5







