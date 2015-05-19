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
IPADDR='172.22.222.2/24'
MTU=''
NAME='Ethernet Card 0'
NETMASK=''
NETWORK=''
REMOTE_IPADDR=''
STARTMODE='auto'
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


sed -i -e 's,with_horizon.*,with_horizon=yes,' /etc/openstackquickstartrc
sed -i -e 's,with_tempest.*,with_tempest=no,' /etc/openstackquickstartrc

suseInsertService sshd
suseRemoveService boot.lvm
suseRemoveService boot.md
suseRemoveService kbd

chmod +x /usr/sbin/openstack-loopback-lvm
chmod +x /etc/init.d/testvm

# not yet :-(
# openstack-quickstart-demosetup

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount


exit 0
