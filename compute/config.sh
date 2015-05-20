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

baseUpdateSysConfig /etc/sysconfig/network/dhcp DHCLIENT_SET_HOSTNAME yes
baseUpdateSysConfig /etc/sysconfig/network/dhcp WRITE_HOSTNAME_TO_HOSTS yes

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

cat > /etc/sysconfig/network/ifcfg-eth0 <<EOF
BOOTPROTO='dhcp4'
BROADCAST=''
ETHTOOL_OPTIONS=''
MTU=''
NAME='Ethernet Card 0'
NETMASK=''
NETWORK=''
REMOTE_IPADDR=''
STARTMODE='onboot'
USERCONTROL='no'
EOF

cat > /etc/sysconfig/network/ifcfg-eth1 <<EOF
BOOTPROTO='static'
BROADCAST=''
ETHTOOL_OPTIONS=''
IPADDR='0.0.0.0/32'
MTU=''
NAME='Ethernet Card 1'
NETMASK=''
NETWORK=''
REMOTE_IPADDR=''
STARTMODE='auto'
USERCONTROL='no'
EOF

echo "cleaning hostname"
echo -n > /etc/HOSTNAME

chmod +x /etc/init.d/boot.local
chmod +x /etc/init.d/compute

suseInsertService sshd
suseRemoveService boot.lvm
suseRemoveService boot.md
suseRemoveService kbd

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount
