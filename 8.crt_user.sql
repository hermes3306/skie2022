drop user cloud;
create user postgres with createdb password 'postgres';
create user cloud with createdb password 'cloud';
create user skie with createdb password 'skie';
create user test with createdb password 'test';
alter user skie with superuser;
alter user test with superuser;
alter user postgres with superuser;
