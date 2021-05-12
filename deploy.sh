#!/bin/bash

#This script is a work in development, I mean...look at it, if it was a beloved family pet I'd put it down.

#Set variables
read -p "Does this server have a domain that points at it, and ports 80 and 443 exposed? (Y/n): " PROCEED
PROCEED=${PROCEED:-Y}
if [ $PROCEED != "Y" ]; then
    echo "Then this won't work...goodbye"
        rm /home/$USER/deploy.sh
        sleep 5
	exit
fi
read -p "Admin email? (for certbot/https): " ADMIN_EMAIL
read -p "Domain? e.g. example.com: " DOMAIN
read -p "Desired Traefik dashboard username?: " USERNAME
read -p "Desired Traefik dashboard password?: " PASSWORD
#Prepare traefik password
sudo export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)
export PASSWORD="0"
read -p "Timezone? (Australia/Hobart): " TIMEZONE
TIMEZONE=${TIMEZONE:-Australia/Hobart}

#Get authority
echo Configuring primary.$DOMAIN node
echo Admin Email - $ADMIN_EMAIL
echo Traefik User - $USERNAME
echo Traefik Pwd Hashed - $HASHED_PASSWORD
echo Timezone - $TIMEZONE
read -p "Is this correct? (Y/n): " PROCEED
PROCEED=${PROCEED:-Y}
if [ $PROCEED != "Y" ]; then
        rm /home/$USER/deploy.sh
        sleep 5
	exit
fi

#Update
sudo /usr/bin/apt-get update && sudo /usr/bin/apt-get full-upgrade -y
export HOSTNAME="primary.$DOMAIN"
echo $HOSTNAME | sudo tee /etc/hostname > /dev/null 2>&1
sudo hostname -F /etc/hostname
sudo timedatectl set-timezone $TIMEZONE

##Install Docker
curl -fsSL get.docker.com -o get-docker.sh
CHANNEL=stable sh get-docker.sh
rm get-docker.sh

#Initiate Docker Swarm
docker swarm init

#Create traefik overlay networks
docker network create --driver=overlay traefik-public

#Add label to this node so we can constrain traefik and portainer to it
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
docker node update --label-add primary=true $NODE_ID

#Deploy traefik and portainer
curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/main/traefik.yml -o traefik.yml
curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/main/portainer.yml -o portainer.yml
export DOMAIN=$DOMAIN
export HASHED_PASSWORD=$HASHED_PASSWORD
export EMAIL=$EMAIL
docker stack deploy -c traefik.yml traefik
docker stack deploy -c portainer.yml portainer
docker swarm update --task-history-limit=1

echo "Deployment (probably) complete... please visit https://traefik."$DOMAIN" and https://portainer."$DOMAIN
sleep 5

#Clean up
rm /home/$USER/deploy.sh
rm /home/$USER/traefik.yml
rm /home/$USER/portainer.yml
clear

#Done
sleep 1
exit
