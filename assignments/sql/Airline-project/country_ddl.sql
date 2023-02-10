-- Country Table
create table if not exists country
(
	iata_country_code char(2),
    name varchar(45)
);

alter table country add constraint `PK_country` primary key(iata_country_code);