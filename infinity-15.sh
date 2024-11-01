#!/bin/bash

rm -rf .repo/local_manifests/

# Rom source repo
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 15 -g default,-mips,-darwin,-notdefault
echo "=================="
echo "Repo init success"
echo "=================="

# Clone local_manifests repository
git clone -b infinity-15 https://github.com/israfilbd/local_manifests .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
/opt/crave/resync.sh
echo "============================"

<!-- NetworkStack -->
 rm -rf packages/modules/NetworkStack && git clone -b lineage-22.0 https://github.com/LineageOS/android_packages_modules_NetworkStack packages/modules/NetworkStack
# Export
export BUILD_USERNAME=ij-israfil
export BUILD_HOSTNAME=crave
export TZ=Asia/Dhaka
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
lunch infinity_RMX1901-user
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
mka bacon
