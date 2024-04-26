cp /opt/bootlocal.sh /home/tc/bootlocal.sh.bak
cp /etc/asound.conf /home/tc/asound.conf.bak
cp tczs/* /etc/sysconfig/tcedir/optional
echo -e "camilladsp64-2.0.3.tcz\ncamillagui-2.1.1.tcz" >> /etc/sysconfig/tcedir/onboot.lst
if [ ! $(grep -Fq "opt/camillagui" /opt/.xfiletool.lst) ]
then
	echo opt/camillagui >> /opt/.xfiletool.lst
fi

