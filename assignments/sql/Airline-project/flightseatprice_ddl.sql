-- Flightseatprice Table
create table if not exists flightSeatPrice
(
	flight_call int,
    aircraft_id int,
    seat_id int,
    price_used double
);
alter table flightSeatPrice add constraint `PK_flightSeatPrice` primary key(flight_call,aircraft_id,seat_id);
alter table flightSeatPrice add constraint `FK_flightSeatPrice_flight` foreign key(flight_call)
references flight(flight_call);

alter table flightSeatPrice add constraint `FK_flightSeatPrice_aircraftSeat` foreign key(aircraft_id)
references aircraftSeat(aircraft_id);
