#!/bin/bash

# Publigator based on VestaCP installer for clean CentOS >= 6.x < 7.0
# ===========================================
CONFIGPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../"
source "$CONFIGPATH/publigator-config.sh"
cd $INSTALLDIR
# ===========================================

pblfile='publigator-0.2.3-beta.zip'

# next need to download Publigator (latest) to /home/admin/web/publigator
wget -N "http://dist.publigator.com/$pblfile"

mkdir /home/admin/web/publigator
mv "$pblfile" /home/admin/web/publigator/
cd /home/admin/web/publigator

unzip "$pblfile"
rm -f "$pblfile"

chown -R admin:admin /home/admin/web/publigator
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;

cd $INSTALLDIR

# move old public_html to public_html.orig
mv "/home/admin/web/$DOMAIN/public_html" "/home/admin/web/$DOMAIN/public_html.orig"

# create symbolic link for Publicator's web folder
ln -s /home/admin/web/publigator/web "/home/admin/web/$DOMAIN/public_html"
chown -h admin:admin "/home/admin/web/$DOMAIN/public_html"

# remove default admin db
v-delete-database admin admin_default

# create db for Publigator
v-add-database admin "$DATABASE" "$DATABASE_USER" "$DATABASE_PASSWORD"

# mysql config for microserver
# wget "$WEBSOURCE/my-micro.cnf"
# mv -f my-micro.cnf /etc/my.cnf

# Import dump...
#

sleep 5

service mysqld restart
service httpd restart
service nginx reload
