#!/bin/bash
docker-compose down -v --remove-orphans
docker system prune -a --volumes --force
# dev modules
rm -r /root/.cfl-dev
