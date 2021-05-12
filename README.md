# <p align="center">Docker Swarm</p>
### <p align="center">A deployment method and collection of basic docker swarm stacks.</p>

## Prerequisites:
* **Ubuntu 20.04 LTS Local or [VPS](https://ca.ovh.com/au/order/vps/)**
* **SSH Access**
* **Firewall configued to allow 80, 443, 22**
* **Public, Static IP**
* **Domain pointing to IP**

## Deployment:
* **This will bring up Docker Swarm, Traefik and Portainer**
```
curl -fsSL https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy.sh -o deploy.sh
sh deploy.sh
rm deploy.sh
```
