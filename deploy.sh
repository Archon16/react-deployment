#!/bin/bash

echo "Deploying the application on port 80 via docker compose"

docker compose down

docker compose up -d

if [ $? -eq 0 ]; then
	echo "Deploy success on port 80"
	docker ps
else
	echo "Deployment Failed!!"
	exit 1
fi
