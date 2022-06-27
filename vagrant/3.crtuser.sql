drop database skie;
drop database vagrant;

drop user skie;
drop user vagrant;

create database skie;
create user skie with password 'skie';
grant all privileges on database skie to skie;

create database vagrant;
create user vagrant with password 'vagrant';
grant all privileges on database vagrant to vagrant ;
