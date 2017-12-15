#!/bin/bash

# Publigator based on VestaCP installer for clean CentOS >= 6.x < 7.0
# ===========================================
CONFIGPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../"
source "$CONFIGPATH/publigator-config.sh"
cd $INSTALLDIR
# ===========================================

# Install mod_fcgid on microservers
if [ "$srv_type" = 'micro' ]; then
    yum -y install mod_fcgid
    cd /usr/local/vesta/data/templates/web
	wget http://c.vestacp.com/0.9.8/rhel/fcgid/httpd.tar.gz
	tar -xzvf httpd.tar.gz
	rm -f httpd.tar.gz
	# come back
	cd $INSTALLDIR
fi

vesta_templates='/usr/local/vesta/data/templates/web'

wget --no-check-certificate "$WEBSOURCE/fcgid/apache_phpfcgid.tpl" -O "$vesta_templates/httpd/pbl_phpfcgid.tpl"
wget --no-check-certificate "$WEBSOURCE/fcgid/apache_phpfcgid.stpl" -O "$vesta_templates/httpd/pbl_phpfcgid.stpl"

chown admin:admin "$vesta_templates/httpd/pbl_phpfcgid"*
chmod a+x "$vesta_templates/httpd/pbl_phpfcgid"*

wget --no-check-certificate "$WEBSOURCE/fcgid/nginx_phpfcgid.tpl" -O "$vesta_templates/nginx/pbl_phpfcgid.tpl"
wget --no-check-certificate "$WEBSOURCE/fcgid/nginx_phpfcgid.stpl" -O "$vesta_templates/nginx/pbl_phpfcgid.stpl"

chown admin:admin "$vesta_templates/nginx/pbl_phpfcgid"*
chmod a+x "$vesta_templates/nginx/pbl_phpfcgid"*

# add the new package for VestaCP
wget --no-check-certificate "$WEBSOURCE/fcgid/phpfcgid.pkg" -O  /usr/local/vesta/data/packages/phpfcgid.pkg

# save original fcgid starter
mv "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter" "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter.orig"

# custom fcgid starter
wget --no-check-certificate "$WEBSOURCE/fcgid/fcgi-starter" -O "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter"

chmod a+x "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter"
chmod go-r "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter"
chown admin:admin "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter"

# change package for admin
v-change-user-package admin phpfcgid
v-change-web-domain-proxy-tpl admin "$DOMAIN" pbl_phpfcgid
v-change-web-domain-tpl admin "$DOMAIN" pbl_phpfcgid
v-restart-web

sleep 5

service nginx reload
service httpd restart