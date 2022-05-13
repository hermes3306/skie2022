create extension plpythonu;
create extension plperlu;

create or replace function foo() returns text as $$
return `/usr/bin/echo -n "hello world from perl!"`;
$$ language plperlu;

select foo();

create or replace function pyfoo() returns text as $$
return 'Hello World from Python!';
$$ language plpythonu;

select pyfoo();


create or replace function pydate() returns text as $$
from datetime import date
today = date.today()
return 'Hello World from Python: ' + today.strftime("%d/%m/%Y");
$$language plpythonu;

select pydate();

