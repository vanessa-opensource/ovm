#!/bin/bash

echo "Starting build deb"

source /etc/profile

dpkg-buildpackage -us -uc
