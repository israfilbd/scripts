#!/bin/bash

rm -rf .repo/local_manifests/

# Local TimeZone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Dhaka /etc/localtime

# Rom source repo
repo init --depth=1 -u https://github.com/AxionAOSP/android.git -b lineage-23.2 --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# Clone local_manifests repository
git clone -b axion-16.2 https://github.com/israfilbd/local_manifests .repo/local_manifests
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
echo ">>> Cherry picking..." && cd frameworks/base && git fetch https://github.com/ij-project/frameworks_base && (git cherry-pick 522af81 || git cherry-pick --skip) && cd ../..
echo "======= Cherry picking Done ======"

# Export
export WITH_GMS=true
export TARGET_CORE_GMS=true
export TARGET_DISABLE_EPPE=true
export BUILD_USERNAME=ij-israfil
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
axion RMX1901 user gms core
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
ax -br
