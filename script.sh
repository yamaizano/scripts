#!/bin/bash

# Local TimeZone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Rom source repo
repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# check if whyred tree exist
for i in "device/xiaomi/whyred" "kernel/xiaomi/whyred" "vendor/xiaomi/whyred"
do
    if [ -d "$i" ]; then
        echo "Removing directory: $i"
        rm -rf "$i"
    else
        echo "Directory not found: $i"
    fi
done

# Clone local_manifests repository
rm -r .repo/local_manifests
git clone -b lineage-21 https://github.com/yamaizano/local_manifests .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
/opt/crave/resync.sh

rm -rf hardware/xiaomi
git clone --depth 1 -b lineage-21 https://github.com/LineageOS/android_hardware_xiaomi.git hardware/xiaomi
echo "============================"

# Export
export BUILD_USERNAME=izano
export BUILD_HOSTNAME=crave
export SKIP_ABI_CHECKS=true
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
lunch lineage_whyred-ap2a-userdebug
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
m bacon
