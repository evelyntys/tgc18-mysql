# Data definition language
$ need to have ; behind

# start mysql
mysql -u root;

# create a database
create database employees;

# show databases
show databases; 

# before we can issue commands for a database
# we must set the current active database
use employees;

# tells you what database you are currently using
select database();

# create a new table, ensure you are in the correct database
# put in columns/fields of the table in the parenthesis
# auto_increment: will be prev + 1
# name of columns, data type and then options
# int unsigned -> unsigned integer
create table employees (
    employee_id int unsigned auto_increment primary key,
    email varchar(320),
    gender varchar(1),
    notes text,
    employment_date date,
    designation varchar(100)
) engine = innodb;

# show the columns in a table
describe employees;

# delete a table
drop table employees;

# inserting rows
insert into employees (
    email, gender, notes, employment_date, designation
) values('jonsnow@email.com', 'm', 'newbie', curdate(), "intern");

# see all the rows in a table 
select * from employees;

# update one row in a table 
# !important to put 'where' when updating -> if not will update ALL THE ROWS 
update employees set email='asd@gmail.com' where employee_id = 1;

# delete one row
delete from employees where employee_id = 1;

create table departments (
    department_id int unsigned auto_increment primary key,
    name varchar(100)
) engine = innodb;

insert into departments(
    name
) values('hr');

# add a new column to an existing table;
alter table employees add column name varchar(100);
ALTER TABLE employees RENAME COLUMN name TO first_name;

# delete columns
alter table employees drop column department_id;

# one parenthesis is one row
insert into departments (name) value ('accounting'), ('human resource'), ('it');

# insert an employee with first_name
insert into employees (
    first_name, email, gender, notes, employment_date, designation
) values('jon snow', 'jonsnow@email.com', 'm', 'newbie', curdate(), "intern");

# primary keys are never reused -> once deleted, it will never be 
# reused again to prevent data inconsistency and security faults

# data type of fk must match pk in the table if not it will not work
# add a fk between employees and departments
# step 1: add the column
alter table employees add column department_id int unsigned not null;
#step 2: indicate the newly added column to be a fk
# department_id = 0 in employees -> cannot reference to FK since department_id=0 does not exist 
alter table employees add constraint fk_employees_departments
    foreign key (department_id) references departments(department_id);
# department_id in employees table will refer to one department_id in departments table;

# delete existing employees (so that we can add in the foreign key) -> delete everything
!no way to undo delete from mysql
delete from employees;

insert into employees(
    first_name, department_id, email, gender, notes, employment_date, designation
) values('tan ah kow', 4, 'tan@ahkow.com', 'm', 'lazy', curdate(), 'old')


create table employees (
    employee_id int unsigned auto_increment primary key,
    email varchar(320),
    gender varchar(1),
    notes text,
    employment_date date,
    designation varchar(100)
) engine = innodb;


create table parents(
    parent_id int unsigned auto_increment primary key,
    name varchar(100) not null,
    contact_no varchar(10) not null,
    occupation varchar(100)
) engine = innodb;

create table locations(
    location_id int unsigned auto_increment primary key,
    name varchar (100) not null,
    address varchar (255) not null
) engine = innodb;

create table students(
    student_id int unsigned auto_increment primary key,
    age int unsigned,
    name varchar(100),
    date_of_birth date
) engine = innodb;

create table addresses(
    address_id int unsigned auto_increment primary key,
    block_number varchar(100),
    street_name varchar(100),
    postal_code varchar(100)
) engine = innodb;

create table available_payment_types(
    payment_types_id int unsigned auto_increment primary key,
    payment_type varchar(255)
) engine = innodb;

create table payments(
    payment_id int unsigned auto_increment primary key,
    payment_mode varchar(255),
    amount float unsigned
) engine = innodb;

create table sessions(
    session_id int unsigned auto_increment primary key,
    datetime datetime
) engine = innodb;

create table student_session(
    student_session_id int unsigned auto_increment primary key
) engine = innodb;

select * from parents;

insert into parents(
    name, contact_no, occupation
) values ('john doe', '98765432', 'salesman');

alter table addresses add parent_id int unsigned not null;

insert into addresses(
    block_number, street_name, postal_code, parent_id
) values('774', 'east coast rd', '558094', 1);

alter table addresses add constraint fk_parent_addresses
    foreign key (parent_id) references parents(parent_id);

alter table available_payment_types add parent_id int unsigned not null;

alter table available_payment_types add constraint fk_parent_payment_types
    foreign key (parent_id) references parents(parent_id);

insert into available_payment_types(
    payment_type, parent_id
) values('paynow', 1);

alter table students add parent_id int unsigned not null;

alter table students add constraint fk_parent_student
foreign key (parent_id) references parents(parent_id);

insert into students(
    parent_id, age, name, date_of_birth
) values(1, 9, 'johnny', '2013-06-23');

insert into locations (
    name, address
) values('activesg swimming pool', 'yishun ring road');

alter table sessions add location_id int unsigned not null;

alter table sessions add constraint fk_location_session
foreign key(location_id) references locations(location_id);

insert into sessions(
    datetime, location_id
) values(curdate(), 1);

alter table student_session add student_id int unsigned not null;
alter table student_session add session_id int unsigned not null;

alter table student_session add constraint fk_student_session_link
foreign key(student_id) references students(student_id);

alter table student_session add constraint fk_session_student_link
foreign key(session_id) references sessions(session_id);

insert into student_session(
    student_id, session_id
) values (1, 1);

alter table payments add parent_id int unsigned not null;
alter table payments add session_id int unsigned not null;
alter table payments add student_id int unsigned not null;

alter table payments add constraint fk_parent_payment
foreign key(parent_id) references parents(parent_id);

alter table payments add constraint fk_payment_session
foreign key(session_id) references sessions(session_id);

alter table payments add constraint fk_payment_student
foreign key(student_id) references students(student_id);

insert into payments(
    parent_id, session_id, student_id, payment_mode, amount
) values(1, 1, 1, 'paynow', 150.10);