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

#printf "\nInstalling SuPHP...\n\n"
#sleep 5

#wget "$WEBSOURCE/publigator-suphp-0.7.2-install.sh" -O publigator-suphp-0.7.2-install.sh
#bash publigator-suphp-0.7.2-install.sh

printf "\nPreparing Publigator for install...\n\n"
sleep 5

wget "$WEBSOURCE/publigator-prepare-script.sh" -O publigator-prepare-script.sh
bash publigator-prepare-script.sh

printf "\nDone! Now you can go to http://$DOMAIN/ for install Publigator.\n\n"
printf "\nDatabase name: admin_$DATABASE"
printf "\nDatabase user: admin_$DATABASE_USER"
printf "\nDatabase password: $DATABASE_PASSWORD\n\n\n"
