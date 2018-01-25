#!/bin/bash

# This script will remove the Nginx server
#  leave and it's configuration files on the Ubuntu instance

#-----------------------------------------------------------#

# get the status of the Nginx server
systemctl --no-pager status nginx

# shut down the Nginx server
systemctl stop nginx

# get the status of the Nginx server
systemctl --no-pager status nginx

# remove Nginx
apt -y remove nginx nginx-common nginx-core

echo

#-----------------------------------------------------------#

exit
