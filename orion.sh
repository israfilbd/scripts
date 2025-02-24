#!/bin/bash

rm -rf .repo/local_manifests/

# Local TimeZone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Dhaka /etc/localtime

# Rom source repo
repo init --depth=1 -u https://github.com/OrionOS-Project/manifest -b vic --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# Clone local_manifests repository
git clone -b abcd https://github.com/israfilbd/local_manifests .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
/opt/crave/resync.sh
echo "============================"

# Mic Fixes
cd frameworks/base/services/core/java/com/android/server/policy && rm -rf PhoneWindowManager.java
wget https://raw.githubusercontent.com/israfilbd/fixes/refs/heads/main/abcd/PhoneWindowManager.java
cd -
echo "========================"
echo "Microphone Fix successful"
echo "========================"

# Export
export BUILD_USERNAME=ij-israfil
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
lunch orion_RMX1901-ap4a-user
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
make orion
