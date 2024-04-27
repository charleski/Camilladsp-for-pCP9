#!/bin/sh

#
# Install script for boot files. Ensure correct permissions
#

cp /etc/asound.conf /home/tc
cp /opt/bootlocal.sh /home/tc

chown root:root asound.conf
chmod 744 asound.conf
cp -f asound.conf /etc/asound.conf

chown root:staff bootlocal.sh
chmod 755 bootlocal.sh
cp -f bootlocal.sh /opt/bootlocal.sh

rm -f asound.conf
rm -f bootlocal.sh
