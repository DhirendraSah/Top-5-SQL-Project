--Library Management System

--Creating Table Branch
create table branch(
	branch_id varchar(10) primary key,
	manager_id varchar(10),
	branch_address varchar(50),
	contact_no varchar(10)

)

--Creating Table Employees
create table employee(
	emp_id varchar(10) primary key,
	emp_name varchar(30),
	position varchar(15),
	salary int,
	branch_id varchar(10)
)

--Creating Table Book
create table book(
	isbn varchar(25) primary key,
	book_title varchar(50),
	category varchar(25),
	rental_price float,
	status varchar(10),
	author varchar(50),
	publisher varchar(50)
)

--Creating Table members
create table members(
	member_id varchar(20) primary key,
	member_name varchar(50),
	member_address varchar(50),
	reg_date date
)

--Creating Table issued_status
create table issued_status(
	issued_id varchar(20) primary key,
	issued_member_id varchar(20),
	issued_book_name varchar(50),
	issued_date date,
	issued_book_isbn varchar(50),
	issued_emp_id varchar(20)
)

----Creating Table return_status
create table return_status(
	return_id varchar(20) primary key,
	issued_id varchar(20),
	return_book_name varchar(50),
	return_date date,
	return_book_isbn varchar(30)
)
-----------------------------------------

--Add foreign Key
--Add foreign key in employee table from primary key on branch table
alter table employee
add constraint fk_branch
foreign key(branch_id)
references branch(branch_id)

--Add foreign key in issued_status table from primary key on member table
alter table issued_status
add constraint fk_member
foreign key(issued_member_id)
references members(member_id)

--Add foreign key in issued_status table from primary key on book table
alter table issued_status
add constraint fk_book
foreign key(issued_book_isbn)
references book(isbn)

--Add foreign key in issued_status table from primary key on employee table
alter table issued_status
add constraint fk_employee
foreign key(issued_emp_id)
references employee(emp_id)

--Add foreign key in return_status table from primary key on issued_status table
alter table return_status
add constraint fk_issued_status
foreign key(issued_id)
references issued_status(issued_id)
--------------------------------------
--Now Insert data by tools
--Right click on table and select EXPORT/IMPORT
--From option Select header on
--------------------------------------

COPY book (isbn,
	book_title,
	category,
	rental_price ,
	status,
	author,
	publisher)
FROM 'D:\Data Analytics\SQL Project\P-2 Library Management System\book.csv'
DELIMITER ','
CSV HEADER;
-------------------------------------

select * from issued_status
select * from book

--CTAS Operations
--Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**
create table book_issued_count a
select b.isbn,b.book_title,count(ist.issued_id) as issue_count
from issued_status as ist
join book as b
on ist.issued_book_isbn=b.isbn
group by 1,2

-- Data Analysis & Findings
--Retrieve All Books in a Specific Category:
select category,book_title
from book
gr






