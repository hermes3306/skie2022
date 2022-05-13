#!/bin/bash
export PATH=`pwd`/pgsql93/bin:"$PATH:."
pg_ctl -D ./data -l logfile restart


