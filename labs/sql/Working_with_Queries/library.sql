create database library;
use library;

CREATE TABLE BOOK 
   (	BOOKID int(15)   PRIMARY KEY auto_increment, 
	BPUB varchar(20), 
	BAUTH varchar(20), 
	BTITLE varchar(25), 
	BSUB varchar(25)
   ) ;


  CREATE TABLE MEMBER 
   (	MID int(4)   PRIMARY KEY auto_increment, 
	MNAME varchar(20), 
	MPHONE numeric(10,0),
        JOINDATE DATE
   ) ;



  CREATE TABLE BCOPY 
   (	C_ID int(4), 
	BOOKID int(15), 
	STATUS varchar(20) CHECK (status in('available','rented','reserved')),
        PRIMARY KEY (C_ID,BOOKID)
   ); 



  CREATE TABLE BRES 
   (	MID int(4) , 
	BOOKID int(15) REFERENCES BOOK, 
	RESDATE DATE,PRIMARY KEY (MID, BOOKID, RESDATE),
        foreign key(mid) references member(mid)
   ) ;




  CREATE TABLE BLOAN 
   (	BOOKID int(4), 
	LDATE DATE, 
	FINE numeric(11,2), 
	MID int(4), 
	EXP_DATE DATE DEFAULT (curdate()+2), 
	ACT_DATE DATE, 
	C_ID int(4),
  FOREIGN KEY (C_ID, BOOKID)
	  REFERENCES BCOPY (C_ID, BOOKID),
 foreign key(mid) references member(mid)
   ) ;
   
   
   
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('IDG Books','Carol','Oracle Bible','Database');
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('TMH','James','Information Systems','I.Science');
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('SPD','Shah','Java EB 5','Java');
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('BPB','Deshpande','P.T.Olap','Database');


Insert into MEMBER (MNAME,MPHONE,JOINDATE) 
values ('rahul',9343438641,(curdate()-3));
Insert into MEMBER (MNAME,MPHONE,joindate)
 values ('raj',9880138898,(curdate()-2));
Insert into MEMBER (MNAME,MPHONE,joindate) 
values ('mahesh',9900780859,curdate());



Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,1,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (2,1,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,2,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (2,2,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,3,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,4,'available');

show tables;


/* a .) NEW_MEMBER: A  procedure that adds a new member to the MEMBER table. For the join date, use CURDATE(). 
Pass all other values to be inserted into a new row as parameters. */

delimiter //
create procedure sp_addMember(mem_name varchar(20),mem_phone_num decimal(10,0))
begin 
	insert into member values(null,mem_name,mem_phone_num,curdate());
end //
delimiter ;

call sp_addMember('virat',9756346362);

select * from member;

-- b.)
/*
NEW_BOOK: A procedure that adds a new book to the book table. columns pass as parameter.
  Create a trigger to insert into bcopy  table whenever insert happens on new_book.
(Here multiple copies can be entered manually)
*/

delimiter //
create procedure sp_insertNewBook(in publisher varchar(20),in author varchar(20),in title varchar(25), in sub varchar(25))
begin
	insert into book(bpub,bauth,btitle,bsub) values(publisher, author, title, sub);
end//
delimiter ;


drop  procedure sp_insertNewBook;

delimiter //
create trigger tr_addBcopy
after insert on book
for each row
begin
	
	insert into bcopy values(1,new.bookid,'available');
end //
delimiter ;

-- drop trigger tr_addBcopy; 
call sp_insertNewBook('Oreally','DJBravo','swing-zara','bowling');
call sp_insertNewBook('Oreally1','DJBravo2','swing-zara3','bowling4');

select * from bcopy;

select * from book;

/*
	-- 3.) NEW_RENTAL: Function to record a new rental. Pass the bID number for the book that is to be  rented, pass MID number into the function. 
    The function should return the due date for the book. Due dates are three days from the date the book is rented. 
    If the status for a book requested is listed as AVAILABLE in the bCOPY table for one copy of this title, then update this b_COPY table and set the status to RENTED. 
    If there is no copy available, the function must return NULL.
    Then, insert a new record into the BLOAN  table identifying the booked date as today's date, the copy ID number, the member ID number, the BOOKID number and the expected return date. 
*/
delimiter //
create function fn_bookAvailability(bid int, mem_id int)
returns  date deterministic
begin
	declare brented varchar(20);
    declare copy_id int;
    declare ret_date date;
	select status,c_id into brented,copy_id from bcopy where bookid = bid order by status limit 1;
    if brented = 'available' then
		update bcopy set status = 'rented' where c_id = copy_id and bookid = bid;
        insert into bloan(bookid,ldate,mid,c_id) values(bid,curdate(),mem_id,copy_id);
		set ret_date  = date_add(curdate(),interval 3 day);
	else 
		set ret_date = null;
	end if;
    return ret_date;
end //
delimiter ;

-- drop function fn_bookAvailability;

start transaction;
select fn_bookAvailability(3,4);
select * from bcopy;
select * from bloan;
select fn_bookAvailability(3,4);
rollback;

desc bloan;

/*
	-- 4.)
	RETURN_book: A  procedure that updates the status of a book (available, rented, or reserved) and sets the return date. 
    Pass the book ID, the copyID and the status to this procedure. Check whether there are reservations for that title, and display a message if it is reserved. 
    Update the RENTAL table and set the actual return date to today’s date. 
    Update the status in the BCOPY table based on the status parameter passed into the procedure
*/

delimiter //
create procedure sp_returnBook(bid int, copy_id int,book_status varchar(20))
begin
	declare check_status varchar(20);
    declare mem_id int;
    select status into check_status from bcopy where book_id = bid and c_id = copy_id;
    if check_status = 'rented' then
		update bloan set act_date = curdate() where bookid = bid and c_id = copy_id;
		select mid into mem_id from bres order by resdate limit 1;
        if mem_id is null then 
			update bcopy set status = 'available' where bookid = bid and c_id = copy_id;
		else
			delete from bres where mid = mem_id and book_id = bid and c_id = copy_id;
            insert into bloan (book_id,ldate,mid,exp_date,act_date,c_id) values(bid,curdate(),mem_id,copy_id);
		end if;
	end if;
end //
delimiter ;


/* 5.) */
delimiter //
create procedure sp_reserveBook(bid int, mem_id int)
begin
	declare date1 date;
    declare msge varchar(100);
    set date1 = fn_bookAvailability(bid, mem_id) ;
    if date1 is null then
		insert into bres values(mem_id,bid,curdate());
        select exp_date into date1 from bloan where bookid=bid;
        set msge = concat("Book is reserved and it will be available on ",date1);
		signal sqlstate '45000'  set message_text = msge;
		
	end if;
end //
delimiter ;

-- drop  procedure sp_reserveBook;
select fn_bookAvailability(3,4);

call sp_reserveBook(3,4);
select * from bres;


select fn_bookAvailability(1,1);
select * from bcopy;
select * from bloan;

call sp_reserveBook(1,3);



















