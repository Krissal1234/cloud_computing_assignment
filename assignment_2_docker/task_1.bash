#!/bin/bash
#maybe think about making it handle if contaiers already are runninf
export PGHOST="postgresDb"
export PGPORT="5432"
export PGDB="universitydb"
export PGUSER="postgres"
export PGPASS="pass"

docker network create uni-net

docker run -dit --name postgresDb --network uni-net \
  -e POSTGRES_PASSWORD=$PGPASS \
  -e POSTGRES_USER=$PGUSER \
  -e POSTGRES_DB=$PGDB  \
  postgres:latest 

docker run -d --name enrollmentsApp --network uni-net -p 8080:8080 \
  -e PGHOST=$PGHOST \
  -e PGPORT=$PGPORT \
  -e PGDB=$PGDB \
  -e PGUSER=$PGUSER \
  -e PGPASS=$PGPASS \
  markvellaum/university:v0.0.1