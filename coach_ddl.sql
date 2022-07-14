create database swimming_coach;

use swimming_coach;

create table parents (
    parent_id int unsigned auto_increment primary key,
    name varchar(100) not null,
    contact_no varchar(10) not null,
    occupation varchar(100)
) engine = innodb;

insert into parents (name, contact_no, occupation)
    values ("Tan Ah Liang", "9999999", "Truck driver");

-- insert multiple parents
insert into parents (name, contact_no, occupation) values  
        ("Mary Sue", "1111111", "Doctor"),
        ("Tan Ah Kow", "22222222", "Programmer");

  -- locations might not have so many in sg itself -> mediumint be enough
create table locations(
    location_id mediumint unsigned auto_increment primary key,
    name varchar(100) not null,
    address varchar(255) not null
) engine = innodb;

insert into locations(name, address)
values('yishun swimming complex', 'yishun ave 4');

-- safer and easier to recover if there is error
# method 1 of creating a table with foreign key
-- ensure that the data type of fk matches what it is in another table
- create the table with the foreign key column but not setting it as a foreign key
create table address(
    address_id int unsigned auto_increment primary key,
    parent_id int unsigned not null,
    block_number varchar(6) not null,
    street_name varchar(255) not null,
    unit_number varchar(100) not null,
    postal_code varchar(10) not null
) engine = innodb;

# add in the foreign key relationship to the parent_id column
-- unique name for every constraint created
-- alter table <table name> add constraint <name of constraint> 
-- foreign key (column of the altered table) references <other table>
alter table address add constraint fk_addresses_parents
foreign key(parent_id) references parents(parent_id);

# address.parent_id will refer to parents.parent_id;

-- for datetime, standardise to one time zone to look at
#create the students table along with the foreign key 
create table students (
    student_id int unsigned auto_increment primary key,
    name varchar(100) not null,
    date_of_birth date not null,
    parent_id int unsigned not null,
    foreign key (parent_id) references parents(parent_id)
) engine = innodb;

-- fk ensures that for every row in student table, every parent_id refers to a valid parent in parents table
-- date: yyyy-mm-dd
insert into students (name, date_of_birth, parent_id) 
values(
    'cindy tan', '2020-06-11', 2
);

delete from parents where parent_id =2; #sql will block it cause it will cause cindy tan to be invalid

-- surround with backtick if the name happens to be a reserved keyword -> have to put `` everything you want to refer to the column
create table session (
    session_id int unsigned auto_increment primary key,
    `datetime` datetime not null,
    location_id int not null, ==> will cause an error because data type is wrong
    foreign key location_id references locations(location_id) 
)

create table session (
    session_id int unsigned auto_increment primary key,
    datetime datetime not null,
    location_id mediumint unsigned not null,
    foreign key (location_id) references locations(location_id) 
);