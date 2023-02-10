-- Booking Table
create table if not exists booking
(
	client_id int,
    flight_call int,
    aircraft_id int,
    seat_id int
);

-- primary key
alter table booking add constraint `PK_booking` primary key(client_id, flight_call,aircraft_id,seat_id);

-- foreign keys
alter table booking add constraint `FK_booking_client` foreign key(client_id)
references client(client_id);
