-- Aircraft Table
create table if not exists aircraft
(
	aircraft_id int,
    aircraft_manufacturer_id int,
    model varchar(45)  unique
);
alter table aircraft add constraint `PK_aircraft` primary key(aircraft_id);
alter table aircraft add constraint `FK_aircraft_aircraftManufacturer` foreign key(aircraft_manufacturer_id)
references aircraftManufacturer(aircraft_manufacturer_id);