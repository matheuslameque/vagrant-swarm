#!/bin/bash

# Defines the path to the worker join script that will be created by the master
WORKER_JOIN_SCRIPT="/vagrant/worker_join_command.sh"

# Waits for the worker join script to be created by the master
echo "Waiting for Docker Swarm join command from master..."
while [ ! -f "$WORKER_JOIN_SCRIPT" ]; do
  sleep 5
done

# Make the join script executable
chmod +x "$WORKER_JOIN_SCRIPT"

# Execute the join command
sudo "$WORKER_JOIN_SCRIPT"
