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

baseStripLocales en fr de ca us
baseStripTranslations en_US

baseUpdateSysConfig /etc/sysconfig/network/dhcp DHCLIENT_SET_HOSTNAME no
baseUpdateSysConfig /etc/sysconfig/network/dhcp WRITE_HOSTNAME_TO_HOSTS no

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

domain=ruler.suse
subnet=172.22.222
controller=2
pool_start=150
pool_end=160

cat > /etc/resolv.conf <<EOF
search $domain
nameserver 127.0.0.1
nameserver 8.8.8.8
EOF

for i in `seq $pool_start $pool_end`; do
    echo $subnet.$i dhcp-$i
done >> /etc/hosts

echo suse.$domain > /etc/HOSTNAME
echo "$subnet.controller   suse.$domain" >> /etc/hosts

sed -i "s/@@SUBNET@@/$subnet/g;
        s/@@DOMAIN@@/$domain/g;
        s/@@POOL_START@@/$pool_start/g;
        s/@@POOL_END@@/$pool_end/g;" \
    /etc/dnsmasq.conf

chkconfig dnsmasq on

cat > /etc/sysconfig/network/ifcfg-eth0 <<EOF
BOOTPROTO='static'
BROADCAST=''
ETHTOOL_OPTIONS=''
IPADDR='$subnet.$controller/24'
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

cat > /etc/sysconfig/network/ifcfg-eth1.9 <<EOF
BOOTPROTO='static'
BROADCAST=''
ETHTOOL_OPTIONS=''
IPADDR='192.168.100.10/23'
MTU=''
NAME='Ethernet Card 1'
NETMASK=''
NETWORK=''
REMOTE_IPADDR=''
STARTMODE='auto'
USERCONTROL='no'
VLAN_ID=9
ETHERDEVICE='eth1'
EOF

cat > /etc/sysconfig/network/ifroute-eth1.9 <<EOF
default 192.168.100.1
EOF

sed -i -e 's,with_horizon.*,with_horizon=yes,' /etc/openstackquickstartrc
sed -i -e 's,with_tempest.*,with_tempest=no,' /etc/openstackquickstartrc

suseInsertService sshd
suseInsertService memcached
suseRemoveService boot.lvm
suseRemoveService boot.md
suseRemoveService kbd

chmod +x /usr/sbin/openstack-loopback-lvm
chmod +x /etc/init.d/testvm
chmod +x /etc/init.d/boot.local

# not yet :-(
# openstack-quickstart-demosetup

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount


exit 0
