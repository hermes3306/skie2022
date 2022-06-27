psql "postgresql://skie:skie@192.168.137.101/skie" <<EOF
create table emp (id int, name text, tel text);
insert into emp values(1, 'john', '1');
insert into emp values(2, 'jam', '1');
insert into emp values(3, 'jun', '1');
insert into emp values(4, 'tom', '1');
insert into emp values(5, 'jane', '1');
EOF
