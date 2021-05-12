# <p align="center">Docker Swarm</p>
### <p align="center">A deployment method and collection of basic docker swarm stacks.</p>

## Prerequisites:
* **Ubuntu 20.04 LTS Local or [VPS](https://ca.ovh.com/au/order/vps/)**
* **SSH Access**
* **Firewall configured to allow 80, 443, 22**
* **Public, static IP**
* **Domain pointing to IP**

## Deployment:
* **This will bring up Docker Swarm, Traefik and Portainer**
```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
curl -fsSL https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy.sh -o deploy.sh && sh deploy.sh
```

## Extension:
* **Follow instructions in each stack.yml file. I'll add it all here as I upload them**
