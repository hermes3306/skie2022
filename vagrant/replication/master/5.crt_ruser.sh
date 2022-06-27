psql "postgresql://postgres:postgres@192.168.137.101/postgres" <<EOF
create user replica with password 'replica' replication
EOF
