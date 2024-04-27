#!/bin/sh

#
# Install script for boot files. Ensure correct permissions
#

chown root:root asound.conf
chmod 744 asound.conf
cp -f asound.conf /etc/asound.conf

chown root:staff bootlocal.sh
chmod 755 bootlocal.sh
cp -f bootlocal.sh /opt/bootlocal.sh

rm -f asound.conf
rm -f bootlocal.sh
