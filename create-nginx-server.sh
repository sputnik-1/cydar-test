#!/bin/bash

# This script will install the Nginx server

#-----------------------------------------------------------#

# install Nginx
apt -y install nginx nginx-common nginx-core

# check it's up and running OK
systemctl --no-pager status nginx

echo

#-----------------------------------------------------------#

exit
