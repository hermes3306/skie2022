sudo yum install perl-ExtUtils*
sudo yum -y install zlib.x86_64 zlib-devel.x86_64
sudo yum -y install readline-devel  readline-devel.x86_64
sudo yum -y install python3 python3-devel
sudo yum install python34-setuptools
sudo easy_install pip

cd ./postgres9.3
make clean
./configure --with-perl --with-python --prefix=`pwd`/../pgsql93
make 	
make all 
make install 
cd ..
