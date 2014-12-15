#!/bin/bash

# ===========================================
CURRENTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALLDIR="$CURRENTDIR/publigator-installer"
WEBSOURCE='https://raw.githubusercontent.com/jetapps-eu/publigator-vps-installer/master'

SERVNAME='__HOSTNAME__'
EMAIL='__EMAIL__'

DOMAIN='__DOMAIN__'
DOMAINIP='__DOMAINIP__'

DATABASE='__DATABASE__'
DATABASE_USER='__DATABASE_USER__'
DATABASE_PASSWORD='__DATABASE_PASSWORD__'
# ===========================================

# Check server type
memory=$(grep 'MemTotal' /proc/meminfo |tr ' ' '\n' |grep [0-9])
srv_type='micro'

if [ "$memory" -gt '1000000' ]; then
    srv_type='small'
fi

if [ "$memory" -gt '3000000' ]; then
    srv_type='medium'
fi

if [ "$memory" -gt '7000000' ]; then
    srv_type='large'
fi
