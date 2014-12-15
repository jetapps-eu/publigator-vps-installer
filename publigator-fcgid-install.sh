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

wget "$WEBSOURCE/fcgid/pbl_phpfcgid.tpl" -O "$vesta_templates/httpd/pbl_phpfcgid.tpl"
wget "$WEBSOURCE/fcgid/pbl_phpfcgid.stpl" -O "$vesta_templates/httpd/pbl_phpfcgid.stpl"

chown admin:admin "$vesta_templates/httpd/pbl_phpfcgid"*
chmod a+x "$vesta_templates/httpd/pbl_phpfcgid"*

# need to create new package for VestaCP
wget "$WEBSOURCE/fcgid/phpfcgid.pkg" -O phpfcgid.pkg
v-add-user-package ./ phpfcgid

# params for fcgid
#echo -e "<IfModule mod_fcgid.c>
#FcgidBusyTimeout 1800
#FcgidIdleTimeout 1800
#FcgidIOTimeout   1800
#FcgidMaxRequestLen 104857600
#FcgidMaxRequestInMem 128000000
#FcgidMaxRequestsPerProcess 1000
#</IfModule>" > "/home/admin/conf/web/httpd.$DOMAIN.conf.fcgid"

#cp "/home/admin/conf/web/httpd.$DOMAIN.conf.fcgid" "/home/admin/conf/web/shttpd.$DOMAIN.conf.fcgid"

#chown root:admin "/home/admin/conf/web/httpd.$DOMAIN.conf.fcgid"
#chown root:admin "/home/admin/conf/web/shttpd.$DOMAIN.conf.fcgid"

#chmod 640 "/home/admin/conf/web/httpd.$DOMAIN.conf.fcgid"
#chmod 640 "/home/admin/conf/web/shttpd.$DOMAIN.conf.fcgid"

# save original fcgid starter
mv "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter" "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter.orig"

# custom fcgid starter
wget "$WEBSOURCE/fcgid/fcgi-starter" -O "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter"

chmod a+x "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter"
chmod go-r "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter"
chown admin:admin "/home/admin/web/$DOMAIN/cgi-bin/fcgi-starter"

service httpd restart
service mysqld restart