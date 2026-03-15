#!/bin/bash

IMAGE_NAME="devops-app"
IMAGE_TAG="latest"

echo "Building Docker image: $IMAGE_NAME:$IMAGE_TAG"

docker build -t $IMAGE_NAME:$IMAGE_TAG .

if [ $? -eq 0 ]; then
	echo "Build success: $IMAGE_NAME:$IMAGE_TAG"
else
	echo "Build Failed!!"
	exit 1
fi
