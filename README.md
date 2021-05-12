# Docker Swarm Stacks
A deployment method and collection of basic docker swarm stacks for my own use.

## Tested on ARM64 Ubuntu 20.04 LTS VPS

## Prerequisites:
* #### SSH Access
* #### WAN Firewall configued to allow 80, 443, 8000

## Deployment:

* ### Set timezone
```
sudo timedatectl set-timezone Australia/Hobart
```

* ### Update
```
sudo apt update && sudo apt full-upgrade -y
```

* ### Become root
```
sudo su
```

* ### Set node hostname
```
export USE_HOSTNAME=primary.<EXAMPLE.DOMAIN>
echo $USE_HOSTNAME > /etc/hostname
hostname -F /etc/hostname
```

* ### Exit root
```
exit
```

* ### Install Docker
```
curl -fsSL get.docker.com -o get-docker.sh && CHANNEL=stable sh get-docker.sh
rm get-docker.sh
```

* ### Set Docker permissions
```
sudo usermod -aG docker $USER && newgrp docker 
```

* ### Enable Docker swarm
```
docker swarm init
```

* ### Check swarm status
```
* docker node ls
```

* ### Get traefik-public network ready
```
docker network create --driver=overlay traefik-public
```

* ### Set deployment variables
```
export EMAIL=<ADMIN_EMAIL>  
export DOMAIN=<EXAMPLE.DOMAIN>
```

* ### Set Traefik dashboard authentication variables
```
export USERNAME=<USERNAME>
export PASSWORD=<PASSWORD>
```

* ### Generate hashed password
```
export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)
```

* ### Create a label on this node so that Traefik and Portainer are always deployed here
```
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
docker node update --label-add primary=true $NODE_ID
```

* ### Configure traefik
```
curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm_stacks/main/traefik.yml -o traefik.yml
```

* ### Configure portainer
```
curl -L https://raw.githubusercontent.com/suodrazah/docker_swarm_stacks/main/portainer.yml -o portainer.yml
```

* ### Deploy
```
docker stack deploy -c traefik.yml traefik && docker stack deploy -c portainer.yml portainer
```

* ### Automatically prune
```
docker swarm update --task-history-limit=4
```

* ### Access Traefik and Portainer
```
traefik.<EXAMPLE.DOMAIN>
portainer.<EXAMPLE.DOMAIN>
```
