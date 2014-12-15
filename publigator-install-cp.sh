#!/bin/bash

# Publigator based on VestaCP installer for clean CentOS >= 6.x < 7.0
# ===========================================
CONFIGPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../"
source "$CONFIGPATH/publigator-config.sh"
cd $INSTALLDIR
# ===========================================

# Check wget
if [ ! -e '/usr/bin/wget' ]; then
    yum -y install wget
    if [ $? -ne 0 ]; then
        echo "Error: can't install wget"
        exit 1
    fi
fi

# Add EPEL repo
wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -O epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm

# Add IUS repo
# wget http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/ius-release-1.0-13.ius.centos6.noarch.rpm
# sudo rpm -Uvh ius-release*.rpm

# Add RPMForge repo
wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm -O rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
rpm -K rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rpm -ivh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

# Try to install `htop`
if [ ! -e '/usr/bin/htop' ]; then
    yum -y install htop
    if [ $? -ne 0 ]; then
        echo "Error: can't install htop"
        exit 1
    fi
fi

# Try to install `nano`
if [ ! -e '/usr/bin/nano' ]; then
    yum -y install nano
    if [ $? -ne 0 ]; then
        echo "Error: can't install nano"
        exit 1
    fi
fi

# Try to install `mc`
if [ ! -e '/usr/bin/mc' ]; then
    yum -y install mc
    if [ $? -ne 0 ]; then
        echo "Error: can't install mc"
        exit 1
    fi
fi

# Update system
yum -y update
if [ $? -ne 0 ]; then
    echo 'Error: yum update failed'
    exit 1
fi

# install compilers and so on
yum -y groupinstall "Development Tools"

#wget http://vestacp.com/pub/vst-install-rhel.sh -O vst-install-rhel.sh
#bash vst-install-rhel -f -n -e youmail@yourmail.com
#bash vst-install-rhel.sh

# Install VestaCP
wget http://vestacp.com/pub/vst-install.sh -O vst-install.sh
bash vst-install.sh -f --hostname "$SERVNAME" --email "$EMAIL"
