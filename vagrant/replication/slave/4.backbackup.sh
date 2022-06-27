sudo -u postgres pg_basebackup -h 192.168.137.101 -U replica -p 5432 -D $PGDATA -Fp -Xs -P -R

