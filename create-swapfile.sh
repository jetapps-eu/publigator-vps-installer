#!/bin/bash

# https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-centos-6
# create swapfile
dd if=/dev/zero of=/swapfile bs=1024 count=512k
mkswap /swapfile
swapon /swapfile
chown root:root /swapfile
chmod 0600 /swapfile

# NOT WORKED on OpenVZ virtualization