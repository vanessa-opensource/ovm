#!/bin/bash

echo "Starting build deb"

source /etc/profile

ls -al ./debian

pwd

dpkg-buildpackage -us -uc
