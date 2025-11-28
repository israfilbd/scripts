#!/bin/bash

rm -rf .repo/local_manifests && \
repo init -u https://github.com/The-Clover-Project/manifest.git -b 16-qpr1 --git-lfs && \
git clone https://github.com/israfilbd/local_manifests --depth 1 -b clover .repo/local_manifests && \
/opt/crave/resync.sh && \
export BUILD_USERNAME=ij-israfil ; \
export BUILD_HOSTNAME=crave ; \
source build/envsetup.sh && \
lunch clover_RMX1901-bp3a-userdebug && \
make installclean && \
mka clover
