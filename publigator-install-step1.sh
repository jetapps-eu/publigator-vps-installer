#!/bin/bash

WEBSOURCE='https://raw.githubusercontent.com/jetapps-eu/publigator-vps-installer/master'

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
echo
echo "Hostname: $SERVNAME"
echo "Email: $EMAIL"
echo
echo "Domain: $DOMAIN"
echo "Domain IP: $DOMAINIP"
echo
echo "Database: admin_$DATABASE"
echo "Database user: admin_$DATABASE_USER"
echo "Database user password: $DATABASE_PASSWORD"

echo
echo

read -p 'Please check the information doubly. If an error, press CTRL+C and start again.'

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

wget --no-check-certificate "$WEBSOURCE/create-swapfile.sh" -O create-swapfile.sh
bash create-swapfile.sh

wget --no-check-certificate "$WEBSOURCE/publigator-install-cp.sh" -O publigator-install-cp.sh
bash publigator-install-cp.sh
