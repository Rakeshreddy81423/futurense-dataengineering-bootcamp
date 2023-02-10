-- Client Table
create table  if not exists client
(
	client_id int not null,
    first_name varchar(45) not null,
    middle_name varchar(45),
    last_name varchar(45),
    phone varchar(45),
    email varchar(45) not null,
    passport varchar(45) not null,
    iata_country_code char(2)    
    
);

-- primary key
alter table client add constraint `PK_client` primary key(client_id);

-- foreign keys
alter table client add constraint `FK_client_country` foreign key(iata_country_code)
references country(iata_country_code);