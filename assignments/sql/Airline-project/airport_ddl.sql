-- Airport table
create table if not exists airport
(
	iata_airport_code char(3),
    name varchar(45),
    city varchar(45),
    iata_country_code char(2)
);

-- primary key
alter table airport add constraint `PK_airport` primary key(iata_airport_code);

-- foreign keys
alter table airport add constraint `FK_airport_country` foreign key(iata_country_code)
references country(iata_country_code);
