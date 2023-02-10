-- FlightStatus table
create table if not exists flightStatus
(
	flight_status_id int,
    name varchar(45)
);
alter table flightStatus add constraint `PK_flightStatus` primary key(flight_status_id);