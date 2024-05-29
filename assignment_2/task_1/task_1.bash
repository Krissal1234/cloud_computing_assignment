#!/bin/bash
export PGHOST="postgresDb"
export PGPORT="5432"
export PGDB="universitydb"
export PGUSER="postgres"
export PGPASS="pass"

docker network create uni-net

if [ "$(docker ps -q -f name=postgresDb)" ]; then
    echo "PostgreSQL container is already running."
else
    docker run -dit --name postgresDb --network uni-net \
      -e POSTGRES_PASSWORD=$PGPASS \
      -e POSTGRES_USER=$PGUSER \
      -e POSTGRES_DB=$PGDB  \
      postgres:latest
fi

if [ "$(docker ps -q -f name=enrollmentsApp)" ]; then
    echo "EnrollmentsApp container is already running."
else
    docker run -d --name enrollmentsApp --network uni-net -p 8080:8080 \
      -e PGHOST=$PGHOST \
      -e PGPORT=$PGPORT \
      -e PGDB=$PGDB \
      -e PGUSER=$PGUSER \
      -e PGPASS=$PGPASS \
      markvellaum/university:v0.0.1
fi