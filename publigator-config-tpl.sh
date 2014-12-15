#!/bin/bash

# ===========================================
CURRENTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALLDIR="$CURRENTDIR/publigator-installer"
WEBSOURCE='http://dist.publigator.com/centos-6.x-installer'

HOSTNAME='{HOSTNAME}'
EMAIL='{EMAIL}'

DOMAIN='{DOMAIN}'
DOMAINIP='{DOMAINIP}'

DATABASE='{DATABASE}'
DATABASE_USER='{DATABASE_USER}'
DATABASE_PASSWORD='{DATABASE_PASSWORD}'
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
