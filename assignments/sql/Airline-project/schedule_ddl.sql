-- Schedule
create table if not exists schedule
(
	schedule_id int,
    origin_iata_airport_code char(3),
    dest_iata_airport_code char(3),
    departure_time_gmt timestamp,
    arrival_time_gmt timestamp
);
alter table schedule add constraint `PK_schedule` primary key(schedule_id);
alter table schedule add constraint `FK_schedule_direction` foreign key(origin_iata_airport_code, dest_iata_airport_code)
references direction(origin_iata_airport_code, dest_iata_airport_code);