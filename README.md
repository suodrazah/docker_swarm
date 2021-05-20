# <p align="center">Docker Swarm</p>
### <p align="center">A deployment method and collection of basic docker swarm stacks.</p>

## tl;dr
```
sudo groupadd docker && sudo usermod -aG docker $USER && newgrp docker
```
```
curl -fsSL https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy.sh -o deploy.sh && sh deploy.sh
```

## Prerequisites:
* **_Tested on_ Ubuntu Server 20.04 LTS Local or VPS.**
  * [VPS at OVH](https://ca.ovh.com/au/order/vps/) _$5+/month_
  * [EC2 VPS at AWS](https://aws.amazon.com/free/) _free tier for 12 months_
* **SSH Access**
* **Firewall configured to allow 80/tcp, 443/tcp, 22/tcp**
* **Public, static IP**
* **Domain pointing to servers public IP address**
  * [Google Domains](https://domains.google.com/) _$18+/year_
  * [No-IP](https://domains.google.com/) _free_

## Notes:
* **Designed to be executed on a fresh platform**
* **All updates are handled**
* **Wait a minute or so for Traefik to come up after the script finishes**

## Deployment:
* **This will bring up Traefik and Portainer on a primary Docker Swarm node**
```
sudo groupadd docker && sudo usermod -aG docker $USER && newgrp docker
```
```
curl -fsSL https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy.sh -o deploy.sh && sh deploy.sh
```

## Add Nodes (same private IPv4 LAN)
* Primary node:
```
docker swarm join-token manager
```
```
sudo groupadd docker && sudo usermod -aG docker $USER && newgrp docker
```
```
curl -fsSL https://get.docker.com -o get-docker.sh $$ sh get-docker.sh
```
* Worker node:
```
docker swarm join-token worker
```
```
sudo groupadd docker && sudo usermod -aG docker $USER && newgrp docker
```
```
curl -fsSL https://get.docker.com -o get-docker.sh $$ sh get-docker.sh
```
* Execute the resulting code on the node to be added
* Add a label to the new node
   * `Portainer`
   * `Swarm`
   * `<node>`
   * `+Label`
   * `Name` - <Node Name> e.g. worker1
   * `Value` - "True"

## Extension:
* Create a new stack
   * `Portainer`
   * `Stacks`
   * `Add Stack`
   * `Name` - e.g. client1-ignition
   * `Web editor` - copy contents of stack.yml file
   * `Environment variables` - as described by the stack comments

## Update:
* Take a server snapshot or backup
* Run the script again
```
curl -fsSL https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy.sh -o deploy.sh && sh deploy.sh
```

## To Do:
* Fix Traefik headers
