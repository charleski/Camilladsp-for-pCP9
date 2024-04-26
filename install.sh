cp tczs/* /etc/sysconfig/tcedir/optional
tce-load -i camilladsp64-2.0.3.tcz camillagui-2.1.1.tcz
if [ ! $(grep -Fq "opt/camillagui" /opt/.xfiletool.lst) ]
then
	echo opt/camillagui >> /opt/.xfiletool.lst
fi

