sudo systemctl stop postgresql
cat pg_hba.conf >> /var/lib/pgsql/data/pg_hba.conf
cat postgresql.conf >> /var/lib/pgsql/data/postgresql.conf
sudo systemctl start postgresql

