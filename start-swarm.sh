#!/bin/bash
# VBoxManage hostonlyif remove vboxnet
set -e

# Docker Machine Setup
docker-machine create \
    -d virtualbox \
    consul-machine

# Run consul
docker $(docker-machine config consul-machine) run -d \
  -p "8500:8500" -p "8302:8302" -p "8301:8301" -p "8300:8300" \
  -h "consul" \
  progrium/consul -server -bootstrap

eval $(docker-machine env consul-machine)
export TOKEN=$(docker run swarm create)

docker-machine create -d virtualbox \
  --swarm --swarm-image="swarm" --swarm-master \
  --swarm-discovery="consul://$(docker-machine ip consul-machine):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip consul-machine):8500" \
  --engine-opt="cluster-advertise=eth1:2376" \
  swarm-master

# docker-machine create -d virtualbox \
#   --swarm --swarm-image="swarm" \
#   --swarm-discovery="consul://$(docker-machine ip consul-machine):8500" \
#   --engine-opt="cluster-store=consul://$(docker-machine ip consul-machine):8500" \
#   --engine-opt="cluster-advertise=eth1:2376" \
#   swarm-agent-00

  ## Let's not start another one, to save memory
  # docker-machine create -d virtualbox \
  #   --swarm --swarm-image="swarm" \
  #   --swarm-discovery="consul://$(docker-machine ip consul-machine):8500" \
  #   --engine-opt="cluster-store=consul://$(docker-machine ip consul-machine):8500" \
  #   --engine-opt="cluster-advertise=eth1:2376" \
  #   swarm-agent-01

eval $(docker-machine env --swarm swarm-master)
docker info

# Get just nodes in swarm
docker run --rm swarm list consul://$(docker-machine ip consul-machine):8500

docker network create --driver overlay build
