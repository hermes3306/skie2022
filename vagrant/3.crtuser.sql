drop database skie;
drop user skie;

create database skie;
create user skie with password 'skie';
grant all privileges on database skie to skie;
