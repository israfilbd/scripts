#!/bin/bash

rm -rf .repo/local_manifests/

# Local TimeZone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Dhaka /etc/localtime

# Rom source repo
repo init --depth=1 -u https://github.com/RisingOS-Revived/android -b sixteen --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# Clone local_manifests repository
git clone -b rising-16 https://github.com/israfilbd/local_manifests .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
/opt/crave/resync.sh
echo "============================"

# Export
export BUILD_USERNAME=ij-israfil
export BUILD_HOSTNAME=crave
export TARGET_HAS_UDFPS=true
export TARGET_PREBUILT_LAWNCHAIR_LAUNCHER=false
echo "======= Export Done ======"

# Mic Fix
echo ">>> Applying frameworks/base patch..." && cd frameworks/base && (git log --oneline | grep -q "dt2w\|DT2W\|double.*tap" || (wget -O temp.patch "https://github.com/ij-project/frameworks_base_evox/commit/c49d293.patch" && (git apply temp.patch && git add . && git commit -m "Apply DT2W patch" || echo "Patch conflicts detected, continuing build...") && rm -f temp.patch)) && cd ../.. && echo ">>> Frameworks/base patch process completed!"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
riseup RMX1901 user
echo "============="

# Build rom
rise b
