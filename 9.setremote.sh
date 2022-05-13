#!/bin/bash
export PATH=`pwd`/pgsql93/bin:"$PATH:."
pg_ctl -D ./data -l logfile stop
cat 9.postgresql.conf >> data/postgresql.conf
cat 9.pg_hba.conf >> data/pg_hba.conf
pg_ctl -D ./data -l logfile start



