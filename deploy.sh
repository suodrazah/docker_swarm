#!/bin/bash

#Don't use this script....
#Hello there
#This script is a work in development, I mean...look at it, if it was a beloved family pet I'd put it down.
#And I'm not an idiot, I realise I could have an if statement for the New deployment and configure variables in there.
#But I want update and new to be doing different things as this develops.
#Good luck



#Update
read -p "Update or New (u/N): " UPDATE
UPDATE=${UPDATE:-N}
if [ $UPDATE = "u" ]; then
    echo "Updating!"

    #Load user details
    . /home/$USER/deploy.conf
    
    echo Traefik dashboard password?
    #Prepare traefik password
    export "HASHED_TFPASSWORD=$(openssl passwd -apr1 $TFPASSWORD)"

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
    
    #Get traefik ready
    curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy/traefik_conf.toml -o /home/${USER?Variable not set}/traefik_conf.toml
    
    #Deploy traefik and portainer
    curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy/traefik.yml -o traefik.yml
    curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy/portainer.yml -o portainer.yml
    export USER=$USER
    export DOMAIN=$DOMAIN
    export HASHED_TFPASSWORD=$HASHED_TFPASSWORD
    export EMAIL=$EMAIL
    export USERNAME=$USERNAME
    docker stack deploy -c traefik.yml traefik
    docker stack deploy -c portainer.yml portainer
    docker swarm update --task-history-limit=1
    clear
    echo "Update (probably) complete... please visit https://traefik."$DOMAIN" and https://portainer."$DOMAIN
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
fi

rm ./deploy.conf
clear
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
read -p "Traefik dashboard username?: " USERNAME
echo Traefik dashboard password?
#Prepare traefik password
export "HASHED_TFPASSWORD=$(openssl passwd -apr1 $TFPASSWORD)"
read -p "Timezone? (Australia/Hobart): " TIMEZONE
TIMEZONE=${TIMEZONE:-Australia/Hobart}

#Get authority
echo Configuring primary.$DOMAIN node
echo Admin Email - $ADMIN_EMAIL
echo Traefik User - $USERNAME
echo Traefik Pwd Hashed - $HASHED_TFPASSWORD
echo Timezone - $TIMEZONE
read -p "Is this correct? (Y/n): " PROCEED
PROCEED=${PROCEED:-Y}
if [ $PROCEED != "Y" ]; then
    rm /home/$USER/deploy.sh
    sleep 5
    exit
fi

#Store user details
rm -f deploy.conf
echo "DOMAIN=$DOMAIN" >> deploy.conf
echo "ADMIN_EMAIL=$ADMIN_EMAIL" >> deploy.conf
echo "USERNAME=$USERNAME" >> deploy.conf
echo "TIMEZONE=$TIMEZONE" >> deploy.conf

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

#Get traefik ready
curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy/traefik_conf.toml -o /home/${USER?Variable not set}/traefik_conf.toml

#Deploy traefik and portainer
curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy/traefik.yml -o traefik.yml
curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy/portainer.yml -o portainer.yml
export USER=$USER
export DOMAIN=$DOMAIN
export HASHED_TFPASSWORD=$HASHED_TFPASSWORD
export EMAIL=$EMAIL
export USERNAME=$USERNAME
docker stack deploy -c traefik.yml traefik
docker stack deploy -c portainer.yml portainer
docker swarm update --task-history-limit=1
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
