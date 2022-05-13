#!/bin/bash
export PATH=`pwd`/pgsql93/bin:"$PATH:."
mkdir ./data
initdb -D ./data
pg_ctl -D ./data -l logfile start


