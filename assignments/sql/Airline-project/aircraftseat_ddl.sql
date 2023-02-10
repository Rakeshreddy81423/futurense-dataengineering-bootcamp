-- AircraftSeat Table
create table if not exists aircraftSeat
(
	aircraft_id int,
    seat_id int,
    travel_class_id int
);
alter table aircraftSeat add constraint `PK_aircraftSeat` primary key(aircraft_id,seat_id);
alter table aircraftSeat add constraint `FK_aircraftSeat_travelClass` foreign key(travel_class_id)
references travelClass(travel_class_id);
alter table aircraftSeat add constraint `FK_aircraftSeat_aircraft` foreign key(aircraft_id)
references aircraft(aircraft_id);