-- Direction Table
create table if not exists direction
(
	origin_iata_airport_code char(3),
    dest_iata_airport_code char(3)
);
alter table direction add constraint `PK_direction` primary key(origin_iata_airport_code,dest_iata_airport_code);
alter table direction add constraint `FK_direction_airport` foreign key(origin_iata_airport_code)
references airport(iata_airport_code);