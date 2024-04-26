#!/bin/sh
# put other system startup commands here

GREEN="$(echo -e '\033[1;32m')"

echo
echo "${GREEN}Running bootlocal.sh..."
#pCPstart------
/usr/local/etc/init.d/pcp_startup.sh >> /var/log/pcp_boot.log 2>&1
#pCPstop------

# CamillaDSP
python3.11 /opt/camillagui/main.py >> /dev/null 2>&1 &
# CamillaDSP
