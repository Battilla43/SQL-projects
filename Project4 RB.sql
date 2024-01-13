create database dvd;

use dvd;

show tables;
 
create table manager
(staff_name varchar(30),
staff_position varchar(20),
salary numeric (12, 2) check (salary > 0),
staff_number numeric (2),
primary key (staff_number));

create table staff
(staff_name varchar(30),
staff_position varchar(20),
salary numeric (12,2) check (salary > 0),
staff_number numeric (2),
primary key (staff_number));

create table branch
(branch_num numeric(20),
staff_name varchar(30),
primary key (branch_num),
foreign key (staff_name) references manager(staff_name));

create table dvd
(catalog_num numeric (5),
dvd_num numeric (5),
title varchar(50),
category varchar(50),
daily_rental numeric (5),          
cost numeric(5),
status_dvd boolean,
main_actors varchar(100),
primary key (catalog_num, dvd_num));

create table customer
(first_name varchar(20),
last_name varchar(20),
street varchar(20),
city varchar(30),
state varchar(30),
zip numeric(10),
cell_num numeric(10),
date_registered varchar(10),
member_num numeric(10),
primary key (member_num));

create table address
(street varchar(20),
city varchar(30),
state varchar(30),
zip numeric(10),
cell_num numeric(10),
foreign key (street, city, state, zip, cell_num) references customer(street, city, state, zip, cell_num)
);

create table rented_dvd
(rental_num numeric(10),
first_name varchar(20),
last_name varchar(20),
member_num numeric(10),
dvd_num numeric(5),
daily_rental numeric(5),
rented_date varchar(10),
returned_date varchar(20),
primary key (rental_num),
foreign key (first_name, last_name, member_num) references customer(first_name, last_name, member_num),
foreign key (dvd_num, daily_rental) references dvd(dvd_num, daily_rental)
);
