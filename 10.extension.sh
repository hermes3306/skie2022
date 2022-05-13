#!/bin/bash
export PATH=`pwd`/pgsql93/bin:"$PATH:."
psql postgres < 10.extension.sql


