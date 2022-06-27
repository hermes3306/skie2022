sudo systemctl stop postgresql
sudo \rm -rf /var/lib/pgsql
sudo yum remove  postgresql-server postgresql-contrib -y
