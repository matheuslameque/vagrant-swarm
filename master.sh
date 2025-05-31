#!/bin/bash

# Initializes a Docker Swarm cluster on the current node, which will act as the manager node and sets the advertise address to the specified IP.
sudo docker swarm init --advertise-addr=192.168.56.102

# Grabs the worker join token from the Docker Swarm manager node.
WORKER_TOKEN=$(sudo docker swarm join-token -q worker)

MANAGER_IP="192.168.56.102"
SWARM_PORT="2377"

# Concatenates the full command to join the Docker Swarm as a worker node.
JOIN_COMMAND="sudo docker swarm join --token ${WORKER_TOKEN} ${MANAGER_IP}:${SWARM_PORT}"

# Writes the join command to a script file that will be created in the /vagrant directory.
echo "${JOIN_COMMAND}" > /vagrant/worker_join_command.sh

# Adds a shebang line to the script file to ensure it is executed as a bash script.
sed -i '1i#!/bin/bash' /vagrant/worker_join_command.sh
