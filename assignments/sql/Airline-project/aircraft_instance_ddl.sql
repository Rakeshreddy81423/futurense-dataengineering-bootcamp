-- AircraftInstance table
create table if not exists aircraftInstance
(
	aircraft_instance_id int,
    aircraft_id int
);

alter table aircraftInstance add constraint `PK_aircraftInstance` primary key(aircraft_instance_id);
alter table aircraftInstance add constraint `FK_aircraftInstance_aircraft` foreign key(aircraft_id)
references aircraft(aircraft_id);