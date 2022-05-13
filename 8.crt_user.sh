#!/bin/bash
export PATH=`pwd`/pgsql93/bin:"$PATH:."
psql postgres < 8.crt_user.sql


