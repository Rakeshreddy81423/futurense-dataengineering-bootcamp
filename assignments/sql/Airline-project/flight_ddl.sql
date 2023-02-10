-- Flight Table
create table if not exists flight
(
	flight_call int,
    schedule_id int,
    flight_status_id int
);
alter table flight add constraint `PK_flight` primary key(flight_call);
alter table flight add constraint `FK_flight_flightStatus` foreign key(flight_status_id)
references flightStatus(flight_status_id);
