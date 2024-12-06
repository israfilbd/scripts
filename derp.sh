#!/bin/bash

rm -rf .repo/local_manifests/

# Rom source repo
repo init --depth=1 -u https://github.com/DerpFest-AOSP/manifest.git -b 15
echo "=================="
echo "Repo init success"
echo "=================="

# Clone local_manifests repository
git clone -b derp-15 https://github.com/ij-israfil/local_manifests .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
/opt/crave/resync.sh
echo "============================"

# Export
export BUILD_USERNAME=ij-israfil
export BUILD_HOSTNAME=crave
export TZ=Asia/Dhaka
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
lunch derp_RMX1901-user
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
mka derp
