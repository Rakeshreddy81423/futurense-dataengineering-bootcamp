-- AircraftManufacturer table
create table if not exists aircraftManufacturer
(
	aircraft_manufacturer_id int,
    name varchar(45)
);

alter table aircraftManufacturer add constraint `PK_aircraftManufacturer` primary key(aircraft_manufacturer_id);