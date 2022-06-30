sudo yum install postgresql-server postgresql-contrib -y
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl status postgresql
sudo passwd postgres
echo 
echo
echo "######################################"
echo "Change password of postgres in psql"
echo "######################################"
