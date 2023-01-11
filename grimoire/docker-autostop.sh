#!/bin/bash

# Get a list of all Docker container IDs
container_ids=$(docker ps -aq)

# Stop and disable auto-start for each container
for id in $container_ids; do
  docker stop $id
  docker update --restart=no $id
done

echo "Auto-start for all Docker containers has been disabled."
