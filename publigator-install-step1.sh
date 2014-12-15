#!/bin/bash

WEBSOURCE='http://dist.publigator.com/centos-6.x-installer'

# copy config
curl -O "$WEBSOURCE/publigator-config-tpl.sh"
# copy config creator
curl -O "$WEBSOURCE/publigator-config-creator.sh"

# copy tpl
cp publigator-config-tpl.sh publigator-config.sh

echo
echo
echo

# request config options
bash publigator-config-creator.sh

# Publigator based on VestaCP installer for clean CentOS >= 6.x < 7.0
# ===========================================
CONFIGPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CONFIGPATH/publigator-config.sh"
# ===========================================

echo "Install directory: $INSTALLDIR" 
echo "Domain: $DOMAIN"
echo "Domain IP: $DOMAINIP"
echo "Email: $EMAIL"
echo "Hostname $HOSTNAME"

echo "Database admin_$DATABASE"
echo "Database user admin_$DATABASE_USER"
echo "Database user password $DATABASE_PASSWORD"

printf "\nInstallation step will take about 15 minutes ...\n\n"
sleep 5

rm -rf $INSTALLDIR
mkdir $INSTALLDIR
cd $INSTALLDIR

# Check wget
if [ ! -e '/usr/bin/wget' ]; then
    yum -y install wget
    if [ $? -ne 0 ]; then
        echo "Error: can't install wget"
        exit 1
    fi
fi

wget "$WEBSOURCE/create-swapfile.sh" -O create-swapfile.sh
bash create-swapfile.sh

wget "$WEBSOURCE/publigator-install-cp.sh" -O publigator-install-cp.sh
bash publigator-install-cp.sh
