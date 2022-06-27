psql "postgresql://skie:skie@192.168.137.101/skie" <<EOF
drop table t1;
create table t1 (col1 int);
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);
EOF
