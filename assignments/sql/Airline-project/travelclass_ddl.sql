-- Travelclass table
create table if not exists travelClass
(
	travel_class_id int,
    name varchar(45),
    description text
);
alter table travelClass add constraint `PK_travelClass` primary key(travel_class_id);