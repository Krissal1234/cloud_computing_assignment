#!/bin/bash
docker stop postgresDb
docker stop enrollmentsApp
docker rm postgresDb
docker rm enrollmentsApp
docker network remove uni-net