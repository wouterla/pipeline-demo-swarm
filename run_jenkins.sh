#!/bin/bash

# Build the images
#build_docker_jenkins.sh
#build_docker_jenkins_builder.sh
#build_docker_jenkins_slave_php.sh
#build_docker_jenkins_slave_java.sh

# Create 'build' network
if docker network inspect build;
then
  echo network build Found
else
  docker network create build;
fi;

# Start Jenkins
docker run -d --net=build \
  -v /home/vagrant/.m2:/root/.m2 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --expose 8080 \
  --name jenkins wouterla/docker-jenkins
# Bootstrap Jenkins Jobs
docker run --net=build wouterla/docker-jenkins-job-builder
