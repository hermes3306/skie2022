psql "postgresql://skie:skie@192.168.137.101/skie" <<EOF
select * from t1;
insert into t1 values(4);
insert into t1 values(5);
insert into t1 values(6);
insert into t1 values(6);
insert into t1 values(7);
insert into t1 values(8);
insert into t1 values(9);
EOF
