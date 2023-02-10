-- drop database FlightDataBase; 
create database FlightDataBase;
use FlightDataBase;


create table states(
iata_state_code char(2) primary key,
state_name varchar(45) not null unique);

create table if not exists client(
client_id int primary key,
first_name varchar(45) not null,
middle_name varchar(45),
last_name varchar(45) not null,
phone varchar(45) unique,
email varchar(45) not null,
passport varchar(45) unique,
iata_state_code char(2) not null,
INDEX names(last_name,first_name),
index cntry_code(iata_state_code)
);

create table flight_status(
flight_status_id int primary key,
name varchar(45) not null);

alter table flight_status add constraint name check (name in ('Scheduled','Delayed','Departed','In Air','Expected','Diverted','Recovery','Landed','Arrived','Cancelled','No Takeoff','Past Flight'));

create table aircraftmanufacturer(
aircraft_manufacturer_id varchar(10) primary key,
name varchar(45) not null unique);



alter table client add constraint fk_state_code 
foreign key(iata_state_code)
references states(iata_state_code)
on update cascade;

create table if not exists airport(
iata_airport_code char(3) primary key,
name varchar(150) not null,
city varchar(45) not null,
iata_state_code char(2),
index ct(city),
index cntry_code(iata_state_code)
);

alter table airport add constraint fk_state_code_airport foreign key(iata_state_code)
references states(iata_state_code)
on update cascade;


create table direction(
origin_iata_airport_code char(3),
dest_iata_airport_code char(3),
distance int default 0
);


alter table direction add constraint chk_dep_arr_location_direction check (origin_iata_airport_code <> dest_iata_airport_code);


alter table direction add constraint pk_origin_desr primary key(origin_iata_airport_code,dest_iata_airport_code);
alter table direction add constraint fk_origin foreign key(origin_iata_airport_code)
references airport(iata_airport_code);
alter table direction add constraint fk_dest foreign key(dest_iata_airport_code)
references airport(iata_airport_code);


create table schedule(
schedule_id int primary key,
origin_iata_airport_code char(3) not null,
dest_iata_airport_code char(3) not null,
departure_time_gmt time not null,
arrival_time_gmt time not null,
departure_date date not null
);

-- alter table schedule add constraint chk_dep_arr_time check (departure_time_gmt<arrival_time_gmt and timestampdiff(hour,arrival_time_gmt, departure_time_gmt));

alter table schedule add constraint chk_dep_arr_location_schedule check (origin_iata_airport_code <> dest_iata_airport_code);

alter table schedule add constraint fk_originate foreign key(origin_iata_airport_code)
references direction(origin_iata_airport_code);
alter table schedule add constraint fk_destination foreign key(dest_iata_airport_code)
references direction(dest_iata_airport_code);

create index origin_dest on schedule(origin_iata_airport_code,dest_iata_airport_code);



create table flight(
flight_call varchar(10) primary key,
schedule_id int not null,
flight_status_id int not null
);


alter table flight add constraint fk_schedule foreign key(schedule_id)
references schedule(schedule_id)
on update cascade;

alter table flight add constraint fk_status_id foreign key(flight_status_id)
references flight_status(flight_status_id)
on update cascade;

create index scheduling on flight(schedule_id,flight_status_id);



create table aircraft(
aircraft_id varchar(10) primary key,
aircraft_manufacturer_id varchar(10),
seats int,
model varchar(45) not null,
index manu_id(aircraft_manufacturer_id)
);


alter table aircraft add constraint fk_manufacturer_id foreign key(aircraft_manufacturer_id)
references aircraftmanufacturer(aircraft_manufacturer_id)
on update cascade;


create table travelclass(
travel_class_id varchar(1) primary key,
name varchar(45) not null,
description text,
index class_name(name));

alter table travelclass add constraint travel_classes check (name in ('Business','Economy'));

create table if not exists aircraftinstance(
aircraft_instance_id int primary key,
aircraft_id varchar(10) not null,
index aircraft_idx(aircraft_id)
);

alter table aircraftinstance add constraint fk_aircraft_id foreign key(aircraft_id)
references aircraft(aircraft_id);

create table flightaircraftinstance(
flight_call varchar(10),
aircraft_instance_id int,
index aircraftinstance_idx(aircraft_instance_id));


alter table flightaircraftinstance add constraint pk_flightaircraftinstance primary key(flight_call,aircraft_instance_id);

alter table flightaircraftinstance add constraint fk_aircraft_instance foreign key(aircraft_instance_id)
references aircraftinstance(aircraft_instance_id)
on update cascade;


-- select * from flightaircraftinstance;

alter table flightaircraftinstance
add constraint ck_flight_call foreign key(flight_call)
references flight(flight_call);

create table if not exists flight(
flight_call varchar(10) primary key,
schedule_id int,
flight_status_id int,
index flight_idx(flight_status_id,schedule_id));

alter table flight add constraint fk_schedule_id foreign key(schedule_id)
references schedule(schedule_id)
on update cascade;


alter table flight add constraint fk_flight_status_id foreign key(flight_status_id)
references flight_status(flight_status_id)
on update cascade;

create table if not exists aircraftseat(
aircraft_id varchar(10),
seat_id varchar(5),
travel_class_id varchar(1),
index aircraftseat_idx(aircraft_id,travel_class_id)
);

alter table aircraftseat add constraint pk_aircraft_id primary key(aircraft_id,seat_id);

alter table aircraftseat add constraint fk_travel_class_id foreign key(travel_class_id)
references travelclass(travel_class_id)
on update cascade;

alter table aircraftseat add constraint fk_aircraft_id_aircraftseat foreign key(aircraft_id)
references aircraft(aircraft_id)
on update cascade;

create index idx_seat_id_aircraftseat on aircraftseat(seat_id);

-- create table if not exists flightseatprice(
-- flight_call varchar(10),
-- aircraft_id varchar(5),
-- seat_id varchar(5),
-- price_usd decimal(8,2) not null,
-- index idx_flightseatprice(flight_call,aircraft_id,seat_id));

-- alter table flightseatprice add constraint pk_flightseatprice primary key(flight_call,aircraft_id,seat_id);

-- alter table flightseatprice add constraint fk_seat_id foreign key(seat_id)
-- references aircraftseat(seat_id)
-- on update cascade;

-- alter table flightseatprice add constraint fk_aircraft_id_flightseatprice foreign key(aircraft_id)
-- references aircraftseat(aircraft_id)
-- on update cascade;

-- alter table flightseatprice add constraint fk_flight_call_flightseatprice foreign key(flight_call)
-- references flight(flight_call)
-- on update cascade;

create table if not exists booking(
client_id int,
flight_call varchar(10),
aircraft_id varchar(10),
seat_id varchar(5),
index idx_booking(aircraft_id,client_id,flight_call,seat_id));

alter table booking add constraint pk_booking primary key(client_id,flight_call, aircraft_id, seat_id);

-- alter table booking add constraint fk_seat_id_booking foreign key(seat_id)
-- references flightseatprice(seat_id)
-- on update cascade;

alter table booking add constraint fk_client_id_booking foreign key(client_id)
references client(client_id)
on update cascade
on delete cascade;

-- alter table booking add constraint fk_flight_call_booking foreign key(flight_call)
-- references flightseatprice(flight_call)
-- on update cascade;


-- alter table booking add constraint fk_aircraft_id_booking foreign key(aircraft_id)
-- references flightseatprice(aircraft_id)
-- on update cascade;


create table if not exists baggageID(
client_id int not null,
flight_call varchar(10) not null,
aircraft_id varchar(5) not null,
baggage_count int not null default 0,
baggage_weight_c decimal(2,2) not null default 0,
baggage_weight_d decimal(2,2) not null default 0,
index idx_booking(aircraft_id,client_id,flight_call));


alter table baggageID add constraint pk_baggageID primary key(client_id, flight_call, aircraft_id);


alter table baggageID add constraint fk_client_id_baggageID foreign key(client_id)
references client(client_id);

alter table baggageID add constraint fk_flight_call_baggageID foreign key(flight_call)
references flight(flight_call);

alter table baggageID add constraint fk_aircraft_id_baggageID foreign key(aircraft_id)
references aircraft(aircraft_id);


-- drop database FlightDataBase;

-- alter table aircraftmanufacturer alter column  aircraft_manufacturer_id varchar(5); 

-- alter table aircraft drop foreign key `fk_manufacturer_id`;
-- alter table aircraftmanufacturer drop primary key;




-- desc aircraftmanufacturer;
-- alter table aircraftmanufacturer add constraint `PK_aircraft_manufacturer_id` primary key(aircraft_manufacturer_id);



-- alter table aircraft add column seats int;

-- select * from aircraft;
-- desc aircraft;

-- alter table aircraftseat drop constraint `fk_aircraft_id_aircraftseat`;
-- alter table aircraftinstance drop constraint `fk_aircraft_id`;
-- alter table 

 

-- alter table aircraft drop primary key;
-- alter table aircraftseat modify column aircraft_id varchar(5);

use flightdatabase;

show tables;
-- select * from aircraftseat;


-- select count(*) from direction;



-- select * from flight_status;


-- select * from schedule limit 100;
-- desc schedule;



select * from direction limit 10;
select * from aircraftseat limit 100;

select count(*)  from schedule;

select * from flight;

-- truncate aircraftseat;