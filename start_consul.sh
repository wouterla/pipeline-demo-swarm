#!/bin/bash
set -x
set -e
export ENV=test
MASTER=$(docker-machine active)
# Get all swarm machines
MACHINES=$(docker-machine ls -q | grep swarm)
# Start consul on all machines
for MACHINE in ${MACHINES};
do
  if [ ${MACHINE} == ${MASTER} ];
  then
    docker run --net=${ENV} -d -e constraint:node==${MACHINE} \
      --expose 8500 --expose 8302 --expose 8301 --expose 8300 \
      --name consul-${MACHINE} \
      -h consul-${MACHINE} \
      progrium/consul \
        -server \
        -bootstrap-expect 1 \
        -bind=$(grep -m 1 consul-${MACHINE} /etc/hosts | cut -f1);
  else
    docker run --net=${ENV} -d -e constraint:node==${MACHINE} \
      --expose 8500 --expose 8302 --expose 8301 --expose 8300 \
      --name consul-${MACHINE} \
      -h consul-${MACHINE} \
      progrium/consul \
        -server \
        -bind=$(grep -m 1 consul-${MACHINE} /etc/hosts | cut -f1);
  fi;
done;
# Join the non-bootstrap consuls to the bootstrap ones
for MACHINE in ${MACHINES};
do
  if [ ${MACHINE} != ${MASTER} ];
  then
    docker exec -t consul-${MACHINE} sh -c 'consul join $(grep -m 1 consul-${MACHINE} /etc/hosts | cut -f1)';
  fi;
done;
