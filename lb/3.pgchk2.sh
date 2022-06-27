#!/bin/bash
 
VALUE=`psql -t "postgresql://postgres:postgres@192.168.137.102/postgres" -c "select pg_is_in_recovery()" 2> /dev/null`

if [ $VALUE == "t" ]
then
    /bin/echo -e "HTTP/1.1 206 OK\r\n"
    /bin/echo -e "Content-Type: Content-Type: text/plain\r\n"
    /bin/echo -e "\r\n"
    /bin/echo "Standby"
    /bin/echo -e "\r\n"
elif [ $VALUE == "f" ]
then
    /bin/echo -e "HTTP/1.1 200 OK\r\n"
    /bin/echo -e "Content-Type: Content-Type: text/plain\r\n"
    /bin/echo -e "\r\n"
    /bin/echo "Primary"
    /bin/echo -e "\r\n"
else
    /bin/echo -e "HTTP/1.1 503 Service Unavailable\r\n"
    /bin/echo -e "Content-Type: Content-Type: text/plain\r\n"
    /bin/echo -e "\r\n"
    /bin/echo "DB Down"
    /bin/echo -e "\r\n"
fi
