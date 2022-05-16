cd ./postgres9.3
make clean
./configure --with-perl --with-python --prefix=`pwd`/../pgsql93
make 	
make all 
make install 
cd ..
