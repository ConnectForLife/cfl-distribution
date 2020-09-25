#!/bin/bash
docker-compose stop
docker-compose -f docker-compose.yml -f docker-compose.override.yml  -f docker-compose.db.yml -f docker-compose.dev.yml -f docker-compose.module-reload.yml up --build -d
sleep 10
curl -L http://localhost:8080/openmrs/ > /dev/null && notify-send -t 10000 -i face-surprise "Demo set up" "" &
docker-compose logs -f --tail 1000
