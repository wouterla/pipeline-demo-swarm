#!/bin/bash
eval $(docker-machine env swarm-master)

export ENV=test

# Create '${ENV}' network
if docker network inspect ${ENV};
then
  echo network ${ENV} Found
else
  docker network create ${ENV};
  echo network ${ENV} created
fi;

# For now set ip using the docker0 device's ip address.
# Needs to be the node ip address later, but that will need to be known anyway
export HOST_IP=$(docker-machine ip swarm-master)

Start base etc in default network so we can point to it from later etcds in other networks
docker run -d -p 4001:4001 -p 2380:2380 -p 2379:2379 --name etcd-bootstrap quay.io/coreos/etcd:v2.0.3 \
 -name etcd0 \
 -advertise-client-urls http://${HOST_IP}:2379,http://${HOST_IP}:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://${HOST_IP}:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://${HOST_IP}:2380 \
 -initial-cluster-state new

 # docker run --net=${ENV} -d --expose 4001 --expose 2380 --expose 2379 --name etcd quay.io/coreos/etcd:v2.0.3 \
 #  -name etcd0 \
 #  -advertise-client-urls http://${HOST_IP}:2379,http://${HOST_IP}:4001 \
 #  -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 #  -initial-advertise-peer-urls http://${HOST_IP}:2380 \
 #  -listen-peer-urls http://0.0.0.0:2380 \
 #  -initial-cluster-token etcd-cluster-1 \
 #  -initial-cluster etcd0=http://${HOST_IP}:2380 \
 #  -initial-cluster-state new

# Start vulcan
docker run -d -p 8182:8182 -p 8181:8181 \
  --name vulcand \
  mailgun/vulcand:v0.8.0-beta.2 \
  /go/bin/vulcand -apiInterface=0.0.0.0 --etcd=http://${HOST_IP}:4001
