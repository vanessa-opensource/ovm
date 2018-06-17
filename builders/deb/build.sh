#!/bin/bash

echo "Starting build deb"

source /etc/profile

DEBBUILDROOT=/opt/deb/

if [ -d "$DEBBUILDROOT" ]; then
    rm -rf $DEBBUILDROOT
    mkdir -p $DEBBUILDROOT
fi

PAKNAME=onescript-version-manager
DSTPATH=${DEBBUILDROOT}${PAKNAME}

mkdir -p $DSTPATH
mkdir -p $DSTPATH/DEBIAN
mkdir -p $DSTPATH/usr/bin
mkdir -p $DSTPATH/usr/share/ovm/bin
mkdir -p $DSTPATH/etc/bash_completion.d

cp /opt/debian/* $DSTPATH/DEBIAN/
cp /opt/builder/ovm $DSTPATH/usr/bin
cp /opt/builder/ovm.exe $DSTPATH/usr/share/ovm/bin
cp /opt/builder/ovm-completion $DSTPATH/etc/bash_completion.d

fakeroot dpkg-deb --build $DSTPATH

rm -rf $DSTPATH
chmod 777 $DSTPATH.deb
dpkg-name -o $DSTPATH.deb

ls -al /opt/deb

cp /opt/deb/*.deb /opt/dist/

ls -al /opt/dist
