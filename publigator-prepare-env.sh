#!/bin/bash

# Publigator based on VestaCP installer for clean CentOS >= 6.x < 7.0
# ===========================================
CONFIGPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../"
source "$CONFIGPATH/publigator-config.sh"
cd $INSTALLDIR
# ===========================================

# stoping services
service httpd stop
service mysqld stop

# remove old mysql driver with deps
yum -y remove php-mysql

# install mysqlnd
yum -y --enablerepo=remi,remi-test install php-mysqlnd phpMyAdmin roundcubemail

# recover configs
#mv -f /etc/roundcubemail/db.inc.php.rpmsave /etc/roundcubemail/db.inc.php
#mv -f /etc/roundcubemail/main.inc.php.rpmsave /etc/roundcubemail/main.inc.php
mv -f /etc/phpMyAdmin/config.inc.php.rpmsave /etc/phpMyAdmin/config.inc.php
mv -f /etc/httpd/conf.d/roundcubemail.conf.rpmsave /etc/httpd/conf.d/roundcubemail.conf
mv -f /etc/httpd/conf.d/phpMyAdmin.conf.rpmsave /etc/httpd/conf.d/phpMyAdmin.conf

# starting services
service mysqld start
service httpd start

# install ioncube
wget http://downloads2.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar zxf ioncube_loaders_lin_x86-64.tar.gz
mv ioncube /usr/local
# need to add to php.ini
#[Zend]
#zend_extension = /usr/local/ioncube/ioncube_loader_lin_5.4.so
#zend_extension_ts = /usr/local/ioncube/ioncube_loader_lin_5.4_ts.so
echo -e "[Zend]\nzend_extension = /usr/local/ioncube/ioncube_loader_lin_5.4.so\nzend_extension_ts = /usr/local/ioncube/ioncube_loader_lin_5.4_ts.so" > /etc/php.d/zz2_zend.ini

# come back
cd $INSTALLDIR

# ICU
wget http://download.icu-project.org/files/icu4c/54.1/icu4c-54_1-src.tgz
tar -xvf icu4c-54_1-src.tgz
cd icu/source/
./runConfigureICU Linux
make
make install

# come back
cd $INSTALLDIR

# install intl.so from pecl
yum -y --enablerepo=remi,remi-test install php-devel
pecl install intl

# install oauth
pecl install oauth
echo "extension=oauth.so" > /etc/php.d/oauth.ini

# install igbinary
pecl install igbinary
echo "extension=igbinary.so" > /etc/php.d/igbinary.ini

# install imagick
yum -y install ImageMagick ImageMagick-devel
pecl install imagick
echo "extension=imagick.so" > /etc/php.d/imagick.ini

# get MaxMind data
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
gunzip GeoLiteCity.dat.gz
mkdir /usr/local/share/GeoIP
mv GeoLiteCity.dat /usr/local/share/GeoIP/GeoIPCity.dat

# install geoip
yum -y --enablerepo=remi,remi-test install GeoIP-devel
pecl install geoip
echo "extension=geoip.so" > /etc/php.d/geoip.ini

# install http (raphf.so and propro.so)
pecl install pecl_http
echo -e "extension=raphf.so\nextension=propro.so" > /etc/php.d/zz1_http.ini
service httpd restart
# install http (http.so)
pecl install pecl_http
# modules in /usr/lib64/php/modules/
echo -e "extension=raphf.so\nextension=propro.so\nextension=http.so" > /etc/php.d/zz1_http.ini

# install opendkim
wget https://github.com/xdecock/php-opendkim/archive/master.zip -O opendkim.zip
unzip opendkim.zip

yum -y install libopendkim.x86_64 libopendkim-devel.x86_64 opendkim.x86_64
cd php-opendkim-master
phpize; ./configure; make;
cp ./modules/opendkim.so /usr/lib64/php/modules/
echo "extension=opendkim.so" > /etc/php.d/opendkim.ini

# php.ini options
sed -i 's#;realpath_cache_size[[:blank:]]*=[[:blank:]]*[[:alnum:]]*#realpath_cache_size = 1M#g' /etc/php.ini
sed -i 's#;realpath_cache_ttl[[:blank:]]*=[[:blank:]]*[[:digit:]]*#realpath_cache_ttl = 120#g' /etc/php.ini
sed -i 's#max_execution_time[[:blank:]]*=[[:blank:]]*[[:digit:]]*#max_execution_time = 900#g' /etc/php.ini
sed -i 's#post_max_size[[:blank:]]*=[[:blank:]]*[[:alnum:]]*#post_max_size = 32M#g' /etc/php.ini
sed -i 's#;default_charset[[:blank:]]*=[[:blank:]]*"UTF-8"#default_charset = "UTF-8"#g' /etc/php.ini
sed -i 's#display_errors[[:blank:]]*=[[:blank:]]*Off#display_errors = On#g' /etc/php.ini
sed -i 's#; max_input_vars[[:blank:]]*=[[:blank:]]*[[:digit:]]*#max_input_vars = 10000#g' /etc/php.ini
sed -i 's#upload_max_filesize[[:blank:]]*=[[:blank:]]*[[:alnum:]]*#upload_max_filesize = 32M#g' /etc/php.ini

sed -i 's#disable_functions[[:blank:]]*=.*#disable_functions = #g' /etc/php.ini
sed -i 's#disable_classes[[:blank:]]*=.*#disable_classes = #g' /etc/php.ini
sed -i 's#open_basedir[[:blank:]]*=.*#;open_basedir = #g' /etc/php.ini

# MySQL options
#wait_timeout=1800
#max_allowed_packet=64M
# need for long php-cli runs
sed -i 's#wait_timeout=[[:digit:]]*#wait_timeout=3600#g' /etc/my.cnf
sed -i 's#interactive_timeout=[[:digit:]]*#interactive_timeout=3600#g' /etc/my.cnf

# additional ngixn config about timeouts and other limits
wget "$WEBSOURCE/nginx.conf" -O nginx.conf

cp nginx.conf "/home/admin/conf/web/nginx.$DOMAIN.conf.limits"
cp nginx.conf "/home/admin/conf/web/snginx.$DOMAIN.conf.limits"

chown root:admin "/home/admin/conf/web/nginx.$DOMAIN.conf.limits"
chown root:admin "/home/admin/conf/web/snginx.$DOMAIN.conf.limits"

chmod 640 "/home/admin/conf/web/nginx.$DOMAIN.conf.limits"
chmod 640 "/home/admin/conf/web/snginx.$DOMAIN.conf.limits"

# restarting services
service mysqld restart
service httpd restart
service nginx reload
