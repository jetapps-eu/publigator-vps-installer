#!/bin/bash

CONFIGPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Password generator
gen_pass() {
    MATRIX='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    LENGTH=10
    while [ ${n:=1} -le ${LENGTH} ]; do
        PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
        let n+=1
    done
    echo "$PASS"
}

# Define email
read -p 'Please enter valid email address: ' email

# Define server hostname
read -p "Please enter hostname ["$(hostname)"]: " servname

if [ -z "$servname" ]; then
    servname=$(hostname)
fi

# Define domain
read -p 'Please enter domain (FQDN) which will be created (ex. publigator.example.com): ' domain

if [ -z "$domain" ]; then
    echo "Error: domain must be specified!"
    exit 1
fi

# Define domain IP
read -p "Please enter domain IP [$(hostname -i)]: " domainip

if [ -z "$domainip" ]; then
    domainip=$(hostname -i)
fi

read -p 'Please enter database name (without prefix "admin_") [publigator]: ' database

if [ -z "$database" ]; then
    database='publigator'
fi

read -p 'Please enter database user (without prefix "admin_") [publigator]: ' database_user

if [ -z "$database_user" ]; then
    database_user='publigator'
fi

read -p 'Please enter database user password [auto]: ' database_password

if [ -z "$database_password" ]; then
    database_password=$(gen_pass)
fi

# sed -i "s#;{TPL}#$var#g" publigator-config.sh

sed -i "s#__HOSTNAME__#${servname}#g" "$CONFIGPATH/publigator-config.sh"
sed -i "s#__EMAIL__#${email}#g" "$CONFIGPATH/publigator-config.sh"

sed -i "s#__DOMAIN__#${domain}#g" "$CONFIGPATH/publigator-config.sh"
sed -i "s#__DOMAINIP__#${domainip}#g" "$CONFIGPATH/publigator-config.sh"

sed -i "s#__DATABASE__#${database}#g" "$CONFIGPATH/publigator-config.sh"
sed -i "s#__DATABASE_USER__#${database_user}#g" "$CONFIGPATH/publigator-config.sh"
sed -i "s#__DATABASE_PASSWORD__#${database_password}#g" "$CONFIGPATH/publigator-config.sh"


printf '\n\nConfiguration created!\n\n'

