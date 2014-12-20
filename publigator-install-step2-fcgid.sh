#!/bin/bash

# Publigator based on VestaCP installer for clean CentOS >= 6.x < 7.0
# ===========================================
CONFIGPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CONFIGPATH/publigator-config.sh"
# ===========================================

echo
echo
echo "Install directory: $INSTALLDIR" 
echo "Domain: $DOMAIN"
echo "Domain IP: $DOMAINIP"
echo "Email: $EMAIL"
echo "Hostname: $HOSTNAME"

echo "Database: admin_$DATABASE"
echo "Database user: admin_$DATABASE_USER"
echo "Database user password: $DATABASE_PASSWORD"

printf "\nInstallation step will take about 15 minutes ...\n\n"
sleep 5

cd $INSTALLDIR

printf "\nPreparing Environment...\n\n"
sleep 5

wget "$WEBSOURCE/publigator-prepare-env.sh" -O publigator-prepare-env.sh
bash publigator-prepare-env.sh

# remove preloaded packages
v-delete-user-package palegreen
v-delete-user-package gainsboro
v-delete-user-package slategrey

# change package for admin
v-change-user-package admin default

# remove default.domain for admin
v-delete-domain admin default.domain

# add new specified domain (with IP and restart-web)
v-add-web-domain admin "$DOMAIN" "$DOMAINIP" yes

# add proxy support
v-add-web-domain-proxy admin "$DOMAIN" default

v-restart-web

printf "\nInstalling Fcgid...\n\n"
sleep 5

wget "$WEBSOURCE/publigator-fcgid-install.sh" -O publigator-fcgid-install.sh
bash publigator-fcgid-install.sh

printf "\nPreparing Publigator for install...\n\n"
sleep 5

wget "$WEBSOURCE/publigator-prepare-script.sh" -O publigator-prepare-script.sh
bash publigator-prepare-script.sh

printf "\nDone! Now you can go to http://$DOMAIN/ for install Publigator.\n\n"
printf "\nDatabase name: admin_$DATABASE"
printf "\nDatabase user: admin_$DATABASE_USER"
printf "\nDatabase password: $DATABASE_PASSWORD\n\n\n"
