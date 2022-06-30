sudo cp pgsqlchk4xinetd /etc/xinetd.d/pgsqlchk
sudo bash -c 'echo "pgsqlchk 23267/tcp # pgsqlchk" >> /etc/services'
sudo systemctl restart xinetd
