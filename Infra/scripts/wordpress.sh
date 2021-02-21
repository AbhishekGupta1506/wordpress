#! /bin/bash

#set hostname
hostnamectl set-hostname --static wordpress

yum update -y

# install and configure docker
yum install -y docker
sudo usermod -aG docker ec2-user
#docker --version
service docker start
service docker status
#docker images

# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
