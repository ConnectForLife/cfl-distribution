#!/bin/bash

docker-compose -f docker-compose.yml -f docker-compose.db.yml -f docker-compose.prod.yml -f docker-compose.module-reload.yml up -d 
