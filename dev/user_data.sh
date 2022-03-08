#!/bin/bash 

#Manually updating the Amazon ECS container agent
sudo mkdir -p /etc/ecs && sudo touch /etc/ecs/ecs.config
sudo echo "ECS_CLUSTER=cw-app-cluster"  >> /etc/ecs/ecs.config

#Installing the Amazon ECS container agent on an Amazon Linux 2 EC2 instance
sudo yum update -y ecs-init
sudo systemctl restart docker
sudo service docker restart && sudo start ecs
