# Docker Swarm Stacks
A deployment method and collection of basic docker swarm stacks for my own use.

## Tested on ARM64 Ubuntu 20.04 LTS VPS

### Set timezone
```sudo timedatectl set-timezone Australia/Hobart```

### Update OS
```sudo apt update && sudo apt full-upgrade -y```

### Becomne root
```sudo su```

### Set node hostname
```export USE_HOSTNAME=primary.<EXAMPLE.DOMAIN>```
```echo $USE_HOSTNAME > /etc/hostname```
```hostname -F /etc/hostname```

### Exit root
```exit```

### Install Docker
```curl -fsSL get.docker.com -o get-docker.sh && CHANNEL=stable sh get-docker.sh```
```rm get-docker.sh```

### Set Docker permissions
```sudo usermod -aG docker $USER && newgrp docker```

### Enable Docker swarm
```docker swarm init```

### Check swarm status
```docker node ls```

### Get traefik-public network ready
```docker network create --driver=overlay traefik-public```

### Set deployemnt variables
```export EMAIL=<ADMIN_EMAIL>```
```export DOMAIN=<EXAMPLE.DOMAIN>```

### Set Traefik dashboard authentication variables
```export USERNAME=<USERNAME>```
```export PASSWORD=<PASSWORD>```

### Generate hashed password
```export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)```

### Configure traefik
```nano ./traefik.yml```

#### Configure portainer
```nano ./portainer.yml```

```docker stack deploy -c traefik.yml traefik && docker stack deploy -c portainer.yml portainer```

### Automatically prune
```docker swarm update --task-history-limit=4```

### Access Traefik and Portainer
#### https://traefik.<EXAMPLE.DOMAIN>
#### https://portainer.<EXAMPLE.DOMAIN>
