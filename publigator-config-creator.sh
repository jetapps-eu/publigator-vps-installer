#!/bin/bash

CONFIGPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Password generator
gen_pass() {
    MATRIX='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    LENGTH=10
    while [ ${n:=1} -le $LENGTH ]; do
        PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
        let n+=1
    done
    echo "$PASS"
}

# Define email
read -p 'Please enter valid email address: ' email

# Define server hostname
read -p "Please enter hostname ["$(hostname)"]: " hostname

if [ -z "$hostname" ]; then
    hostname=$(hostname)
fi

# Define domain
read -p 'Please enter domain which will be created: ' domain

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

sed -i 's#{HOSTNAME}#'$hostname'#g' "$CONFIGPATH/publigator-config.sh"
sed -i 's#{EMAIL}#'$email'#g' "$CONFIGPATH/publigator-config.sh"

sed -i 's#{DOMAIN}#'$domain'#g' "$CONFIGPATH/publigator-config.sh"
sed -i 's#{DOMAINIP}#'$domainip'#g' "$CONFIGPATH/publigator-config.sh"

sed -i 's#{DATABASE}#'$database'#g' "$CONFIGPATH/publigator-config.sh"
sed -i 's#{DATABASE_USER}#'$database_user'#g' "$CONFIGPATH/publigator-config.sh"
sed -i 's#{DATABASE_PASSWORD}#'$database_password'#g' "$CONFIGPATH/publigator-config.sh"


printf '\n\nConfiguration created!\n\n'

