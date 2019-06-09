#! /bin/bash

sudo yum install -y yum-utils
sudo yum install -y yum-config-manager
sudo yum install -y device-mapper-persistent-data
sudo yum install -y lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable docker-ce-edge
sudo yum-config-manager --enable docker-ce-test
sudo yum install docker-ce -y
sudo yum install docker-compose -y
sudo yum list docker-ce --showduplicates | sort -r
sudo systemctl start docker