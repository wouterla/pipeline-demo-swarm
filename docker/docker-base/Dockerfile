FROM ubuntu:15.10
MAINTAINER Wouter Lagerweij <wouter@lagerweij.com>

RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y software-properties-common apt-transport-https ca-certificates

# Add key for Docker repo
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

RUN add-apt-repository -y universe

RUN apt-get install -y python-software-properties

RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-add-repository -y ppa:ansible/ansible

RUN echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y git maven groovy netcat ansible openjdk-8-jdk wget curl docker-engine

#RUN wget -qO- https://get.docker.com/ | sh

RUN mkdir -p /work
VOLUME /work
