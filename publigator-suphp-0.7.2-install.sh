#!/bin/bash

# Publigator based on VestaCP installer for clean CentOS >= 6.x < 7.0
# ===========================================
CONFIGPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../"
source "$CONFIGPATH/publigator-config.sh"
cd $INSTALLDIR
# ===========================================

vesta_templates='/usr/local/vesta/data/templates/web'

wget "$WEBSOURCE/suphp/apache_suphp.tpl" -O "$vesta_templates/httpd/suphp.tpl"
wget "$WEBSOURCE/suphp/apache_suphp.stpl" -O "$vesta_templates/httpd/suphp.stpl"

chown admin:admin "$vesta_templates/httpd/suphp"*
chmod a+x "$vesta_templates/httpd/suphp"*

wget "$WEBSOURCE/suphp/nginx_suphp.tpl" -O "$vesta_templates/nginx/suphp.tpl"
wget "$WEBSOURCE/suphp/nginx_suphp.stpl" -O "$vesta_templates/nginx/suphp.stpl"

chown admin:admin "$vesta_templates/nginx/suphp"*
chmod a+x "$vesta_templates/nginx/suphp"*

# suphp package
wget "$WEBSOURCE/suphp/suphp.pkg" -O  /usr/local/vesta/data/packages/suphp.pkg

yum -y install httpd-devel

wget -c http://www.suphp.org/download/suphp-0.7.2.tar.gz
tar -xzf suphp-0.7.2.tar.gz
cd suphp-0.7.2
autoreconf -vif
./configure --quiet --prefix=/usr --sysconfdir=/etc --with-apr=/usr/bin/apr-1-config --with-apxs=/usr/sbin/apxs --with-apache-user=apache --with-setid-mode=paranoid --with-logfile=/var/log/httpd/suphp_log
make -j12 && make install

cd $INSTALLDIR

wget "$WEBSOURCE/suphp/suphp.conf" -O /etc/suphp.conf
sed -i 's#;x-httpd-php54="php:/opt/php54/bin/php-cgi"#x-httpd-php54="php:/usr/bin/php-cgi"#g' /etc/suphp.conf

if [ `uname -m` == "x86_64" ]; then archlib="lib64"; else archlib="lib"; fi

# save original php config
mv /etc/httpd/conf.d/php.conf /etc/httpd/conf.d/php.conf.bak

cat>/etc/httpd/conf.d/php.suphp.conf<<EOF
LoadModule  suphp_module  /usr/$archlib/httpd/modules/mod_suphp.so
<IfModule mod_suphp.c>
<FilesMatch "\.(inc|php|php3|php4|php5|php6|phtml|phps)$">
#AddHandler x-httpd-php52 .inc .php .php3 .php4 .php5 .phtml
#AddHandler x-httpd-php53 .inc .php .php3 .php4 .php5 .phtml
AddHandler x-httpd-php54 .inc .php .php3 .php4 .php5 .phtml
#AddHandler x-httpd-php55 .inc .php .php3 .php4 .php5 .phtml
</FilesMatch>

AddType text/html .php
DirectoryIndex index.php

<Location />
suPHP_Engine on
suPHP_ConfigPath /etc/
suPHP_AddHandler x-httpd-php52
suPHP_AddHandler x-httpd-php53
suPHP_AddHandler x-httpd-php54
suPHP_AddHandler x-httpd-php54
</Location>
</IfModule>
EOF

# as php runs as cgi
sed -i 's#Timeout 30#Timeout 900#g' /etc/httpd/conf/httpd.conf

# change package for admin
v-change-user-package admin suphp
v-change-web-domain-proxy-tpl admin "$DOMAIN" suphp
v-change-web-domain-tpl admin "$DOMAIN" suphp
v-restart-web

sleep 5

service nginx reload
service httpd restart
