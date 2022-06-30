sudo yum install -y telnet
sudo yum install -y httpd
sudo yum install -y haproxy
sudo yum -y install xinetd

sudo systemctl enable httpd
sudo systemctl enable haproxy
sudo systemctl enable xinetd

sudo systemctl start httpd
sudo systemctl start haproxy
sudo systemctl start xinetd
