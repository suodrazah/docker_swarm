#!/bin/bash
# Copyright 2021 suo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# <http://www.gnu.org/licenses/>.


#Hello there
#This script is a work in development, I mean...look at it, if it was a beloved family pet I'd put it down.
#Good luck


export BRANCH=main

read -p "Does this server have a domain that points at it, and ports 80 and 443 exposed? (Y/n): " PROCEED
PROCEED=${PROCEED:-Y}
if [ $PROCEED != "Y" ]; then
    echo "Then this won't work...goodbye"
    rm /home/$USER/deploy.sh
    sleep 5
    exit
fi

read -p "Admin email? (for certbot/https): " EMAIL

read -p "Domain? (e.g. example.com): " DOMAIN

read -p "Timezone? (Australia/Hobart): " TIMEZONE
TIMEZONE=${TIMEZONE:-Australia/Hobart}

read -p "Traefik dashboard username?: " USERNAME

echo "Traefik dashboard password?"

#Prepare traefik password
export "HASHED_TFPASSWORD=$(openssl passwd -apr1 $TFPASSWORD)"

clear
#Get ZeroTier config ready
read -p "Zerotier Network ID? (Press enter to ignore): " ZEROTIER
ZEROTIER=${ZEROTIER:-X}

clear
#Get authority
echo "Configuring manager."DOMAIN" node"
echo "Admin Email - "$EMAIL
echo "Traefik User - "$USERNAME
echo "Traefik Pwd Hashed - "$HASHED_TFPASSWORD
echo "Timezone - "$TIMEZONE
echo "Zerotier Network - "$ZEROTIER
read -p "Is this correct? (Y/n): " PROCEED
PROCEED=${PROCEED:-Y}
if [ $PROCEED != "Y" ]; then
    rm /home/$USER/deploy.sh
    sleep 5
fi

if [ $ZEROTIER != "X" ]; then
    #Join zerotier network
    curl -s https://install.zerotier.com | sudo bash
    clear
    sudo zerotier-cli join $ZEROTIER
    sleep 5
 fi

#Configure firewall
#sudo apt install ufw && sudo ufw default deny incoming && sudo ufw default allow outgoing && sudo ufw allow 22/tcp && sudo ufw allow 80/tcp && sudo ufw allow 443/tcp && sudo ufw --force enable

#Update
sudo /usr/bin/apt-get update && sudo /usr/bin/apt-get full-upgrade -y
export HOSTNAME="manager.$DOMAIN"
echo $HOSTNAME | sudo tee /etc/hostname > /dev/null 2>&1
sudo hostname -F /etc/hostname
sudo timedatectl set-timezone $TIMEZONE

##Install Docker
curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
rm get-docker.sh

#Initiate Docker Swarm
docker swarm init

#Create traefik overlay networks
docker network create --driver=overlay traefik-public

#Add label to this node so we can constrain traefik and portainer to it
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
docker node update --label-add manager=true $NODE_ID

#Get traefik ready
curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/$BRANCH/deploy/traefik.dynamic.yaml -o /home/${USER?Variable not set}/traefik.dynamic.yaml

#Deploy traefik and portainer
curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/$BRANCH/deploy/traefik.yml -o traefik.yml
curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/$BRANCH/deploy/portainer.yml -o portainer.yml
export USER=$USER
export DOMAIN=$DOMAIN
export HASHED_TFPASSWORD=$HASHED_TFPASSWORD
export EMAIL=$EMAIL
export USERNAME=$USERNAME
docker stack deploy -c traefik.yml manager_traefik
docker stack deploy -c portainer.yml manager_portainer
docker swarm update --task-history-limit=4
clear
echo "Deployment (probably) complete... please visit https://traefik."$DOMAIN" and https://portainer."$DOMAIN
echo "Exiting in a few seconds"
sleep 10

#Clean up
rm /home/$USER/deploy.sh
rm /home/$USER/traefik.yml
rm /home/$USER/portainer.yml
clear

#Done
sleep 1
exit
