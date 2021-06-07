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

read -p "Worker Hostname?: " HOSTNAME
echo $HOSTNAME | sudo tee /etc/hostname > /dev/null 2>&1
sudo hostname -F /etc/hostname
sudo apt update && sudo apt full-upgrade -y && curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
exit
