#!/bin/sh
#
# Install squashed filestystem for camilladsp
#

cp tczs/* /etc/sysconfig/tcedir/optional
echo -e "camilladsp64-3.0.0.tcz\ncamillagui-3.0.0.tcz" >> /etc/sysconfig/tcedir/onboot.lst
if [ ! $(grep -Fq "opt/camillagui" /opt/.xfiletool.lst) ]
then
	echo opt/camillagui >> /opt/.xfiletool.lst
fi

