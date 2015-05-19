#!/bin/bash
# vim: sw=4 et
#================
# FILE          : config.sh
#----------------
# PROJECT       : OpenSuSE KIWI Image System
# COPYRIGHT     : (c) 2006 SUSE LINUX Products GmbH. All rights reserved
#               :
# AUTHOR        : Marcus Schaefer <ms@suse.de>
#               :
# BELONGS TO    : Operating System images
#               :
# DESCRIPTION   : configuration script for SUSE based
#               : operating systems
#               :
#               :
# STATUS        : BETA
#----------------
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

suseSetupProduct
suseImportBuildKey

baseStripLocales en_US
baseStripTranslations en_US

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

cat > /etc/sysconfig/network/ifcfg-eth0 <<EOF
BOOTPROTO='static'
BROADCAST=''
ETHTOOL_OPTIONS=''
IPADDR='0.0.0.0/32'
MTU=''
NAME='Ethernet Card 0'
NETMASK=''
NETWORK=''
REMOTE_IPADDR=''
STARTMODE='auto'
USERCONTROL='no'
EOF

echo cleaning hostname
echo -n > /etc/HOSTNAME

chmod +x /etc/init.d/after.local
chmod +x /etc/init.d/compute

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount
