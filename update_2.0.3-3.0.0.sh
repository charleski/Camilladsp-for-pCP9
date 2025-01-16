#!/bin/sh

git clone -n --depth=1 --filter=tree:0 \
  https://github.com/charleski/Camilladsp-for-pCP9.git
cd Camilladsp-for-pCP9
git sparse-checkout set --no-cone /tczs
git checkout

cp -f tczs/* /etc/sysconfig/tcedir/optional

sed -i "s/camilladsp64-2\.[[:digit:]]\.[[:digit:]]/camilladsp64-3.0.0/g" /etc/sysconfig/tcedir/onboot.lst
sed -i "s/camillagui-2\.[[:digit:]]\.[[:digit:]]/camillagui-3.0.0/g" /etc/sysconfig/tcedir/onboot.lst

cd ..
rm -rf Camilladsp-for-pCP9

