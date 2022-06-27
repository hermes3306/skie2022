sudo systemctl stop postgresql
sudo -u postgres cat pg_hba.conf >> /var/lib/pgsql/data/pg_hba.conf
sudo -u postgres cat postgresql.conf >> /var/lib/pgsql/data/postgresql.conf
sudo systemctl start postgresql

