psql "postgresql://skie:skie@192.168.137.102/skie" <<EOF
select * from emp;
EOF
echo
echo
echo
echo
psql "postgresql://skie:skie@192.168.137.103/skie" <<EOF
select * from emp;
EOF
