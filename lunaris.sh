#!/bin/bash

rm -rf .repo/local_manifests/

# Local TimeZone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Dhaka /etc/localtime

# Rom source repo
repo init --depth=1 -u https://github.com/Lunaris-AOSP/android -b 16.2 --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# Clone local_manifests repository
git clone -b lunaris https://github.com/israfilbd/local_manifests .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
/opt/crave/resync.sh
echo "============================"

# Remove Project
rm -rf hardware/interfaces/sensors/2.0/multihal
echo "======= Remove Done ======"

# UDFPS & Mic Fix
echo ">>> Cherry picking..." && cd frameworks/base && git fetch https://github.com/ij-project/frameworks_base && (git cherry-pick e98cb38 || git cherry-pick --skip) && cd ../..
echo "======= Cherry picking Done ======"

# Export
export WITH_GMS=true
export WITH_GMS_COMMS_SUITE=false
export WITH_PIXEL_LAUNCHER=false
export TARGET_OPTIMIZED_DEXOPT=true
export TARGET_USE_GPHOTOS=false
export TARGET_USE_WALLPAPERS=false
export BUILD_USERNAME=ij-israfil
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"

# Set up build environment
source b*/env*
echo "====== Envsetup Done ======="

# Lunch
lunch lineage_RMX1901-bp4a-user
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
m bacon
