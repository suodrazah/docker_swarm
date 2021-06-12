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
* **_Tested on_ Ubuntu Server 20.04 LTS and Debian 10, Local or VPS.**
  * [VPS at Linode](https://www.linode.com/products/shared/) _$5+/month_
  * [VPS at OVH](https://ca.ovh.com/au/order/vps/) _$5+/month_
  * [EC2 VPS at AWS](https://aws.amazon.com/free/) _free tier for 12 months_
* **SSH Access as sudo user (not root)**
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
* **This will bring up Traefik and Portainer on a manager Docker Swarm node**
```
sudo groupadd docker && sudo usermod -aG docker $USER && newgrp docker
```
```
curl -fsSL https://raw.githubusercontent.com/suodrazah/docker_swarm/main/deploy.sh -o deploy.sh && sh deploy.sh
```

## Extension (i.e. add self hosted software):
* Read the comments at the top of the stack you wish to deploy
* Create a new stack
   * `Portainer`
   * `Stacks`
   * `Add Stack`
   * `Name` - e.g. client1-ignition
   * `Web editor` - copy contents of stack.yml file
   * `Environment variables` - as described by the stack comments

## Add Nodes
* Specific subdomain (e.g. worker1.example.com) shall be configured to point at the new node public IP. Note this subdomain for entry as the node domain when requested upon execution of the script. You can use private IPs instead if so desired.
* Additional configuration of your [firewalls](https://docs.docker.com/engine/swarm/swarm-tutorial/#open-protocols-and-ports-between-the-hosts) is required for swarm communication

* To add a manager node run this on an existing manager node and copy the output:
```
docker swarm join-token manager
```
* To add a worker node run this on a manager node and copy the output:
```
docker swarm join-token worker
```
* On the node to be added (not as root):
```
sudo groupadd docker && sudo usermod -aG docker $USER && newgrp docker
```
```
curl -fsSL https://raw.githubusercontent.com/suodrazah/docker_swarm/main/add_worker.sh -o add_worker.sh && sh add_worker.sh
```
* Output you copied earlier from join-token command above
```
docker swarm join --token KEY IP:2377
```

* Add a label to the new node
   * `Portainer`
   * `Swarm`
   * `<node>`
   * `+Label`
   * `Name` - <Node Name> e.g. worker1
   * `Value` - "True"

 ## To Do
 
 * Fix Traefik headers
