-- FlightAircraftInstance Table
create table if not exists flightAircraftInstance
(
	flight_call int,
    aircraft_instance_id int
);


alter table flightAircraftInstance add constraint `PK_flightAircraftInstance` primary key(flight_call,aircraft_instance_id);
alter table flightAircraftInstance add constraint `FK_flightAircraftInstance_flight` foreign key(flight_call)
references flight(flight_call);
alter table flightAircraftInstance add constraint `FK_flightAircraftInstance_aircraftInstance` foreign key(aircraft_instance_id)
references aircraftInstance(aircraft_instance_id);