cd ./postgres9.3
./configure --with-perl --with-python --prefix=`pwd`/../pgsql93
make 	
make all 
make install 
cd ..
