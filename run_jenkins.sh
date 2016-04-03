#!/bin/bash

# Build the images
#build_docker_jenkins.sh
#build_docker_jenkins_builder.sh
#build_docker_jenkins_slave_php.sh
#build_docker_jenkins_slave_java.sh

eval $(docker-machine env swarm-master)
docker-machine env swarm-master

# Create 'build' network
if docker network inspect build;
then
  echo network build Found
else
  docker network create build;
fi;

DOCKER_IP=$(docker-machine ip swarm-master)

# Start Jenkins
docker run -d --net=build \
  --env DOCKER_IP="${DOCKER_IP}" \
  --env DOCKER_HOST="--tlsverify --tlscacert=/root/docker_files/machine/certs/ca.pem --tlscert=/root/docker_files/machine/certs/cert.pem --tlskey=/root/docker_files/machine/certs/key.pem -H=tcp://${DOCKER_IP}:2376" \
  -v $HOME/.docker:/root/docker_files:ro \
  -p 8080:8080 \
  --name jenkins wouterla/docker-jenkins:2.0
# Bootstrap Jenkins Jobs
#docker run --net=build wouterla/docker-jenkins-job-builder
