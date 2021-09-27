#!/bin/bash
docker-compose down -v
docker-compose -f docker-compose.yml up --build --force-recreate --always-recreate-deps -d
sleep 10
curl -L http://localhost:8080/openmrs/ > /dev/null
