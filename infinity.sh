#!/bin/bash

rm -rf .repo/local_manifests/

# Local TimeZone
echo 'export TZ="Asia/Dhaka"' >> ~/.bashrc
source ~/.bashrc && date

# Rom source repo
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 17 -g default,-mips,-darwin,-notdefault
echo "=================="
echo "Repo init success"
echo "=================="

# Clone local_manifests repository
git clone -b infinity-17 https://github.com/israfilbd/local_manifests .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc)
echo "============================"

# Remove Project
rm -rf hardware/interfaces/sensors/2.0/multihal
echo "======= Remove Done ======"

# UDFPS & Mic Fix
echo ">>> Cherry picking..." && cd frameworks/base && git fetch https://github.com/ij-project/frameworks_base && (git cherry-pick df727e5 || git cherry-pick --skip) && cd ../..
echo "======= Cherry picking Done ======"

# Export
export TARGET_HAS_UDFPS=true
echo "======= Export Done ======"

# Set up build environment
. build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
lunch infinity_RMX1901-user
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
m bacon
