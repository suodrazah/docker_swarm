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

read -p "Node Domain Name? (e.g. worker1.example.com): " WORKERDOMAIN
read -p "Node Label? (e.g. worker1, worker2): " WORKER
read -p "Public IP? " WORKERIP
read -p "sudo user SSH Username? " WORKERUSERNAME
read -p "SSH Password? " WORKERPASSWORD

sudo apt update
sudo apt install sshpass -y

#Install Docker ready to join swarm
sshpass -f <(printf '%s\n' $WORKERPASSWORD) ssh $WORKERUSERNAME@$WORKERIP "echo $WORKERPASSWORD | sudo -S apt update && sudo apt full-upgrade -y && curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"

#Set node hostname
sshpass -f <(printf '%s\n' $WORKERPASSWORD) ssh $WORKERUSERNAME@$WORKERIP "sudo tee /etc/hostname > /dev/null 2>&1"
sshpass -f <(printf '%s\n' $WORKERPASSWORD) ssh $WORKERUSERNAME@$WORKERIP "sudo hostname -F /etc/hostname > /dev/null 2>&1"

#Join Swarm


#Add label to this node so we can constrain traefik and portainer to it
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
docker node update --label-add $WORKER=true $NODE_ID

exit
