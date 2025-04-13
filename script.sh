#!/bin/bash

rm -rf .repo/local_manifests/

# Local TimeZone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Rom source repo
repo init -u https://github.com/Havoc-OS-Revived/android_manifest.git -b eleven --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# check if whyred tree exist
for i in "device/xiaomi/whyred" "kernel/xiaomi/whyred" "vendor/xiaomi/whyred" "packages/apps/Settings" "packages/providers/DownloadProvider" "vendor/qcom/opensource/commonsys/system/bt" "external/dng_sdk" "external/chromium-webview/patches" "external/chromium-webview"
do
    if [ -d "$i" ]; then
        echo "Removing directory: $i"
        rm -rf "$i"
    else
        echo "Directory not found: $i"
    fi
done

# Clone local_manifests repository
git clone -b havoc https://github.com/yamaizano/local_manifests .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
/opt/crave/resync.sh
echo "============================"

# Export
export BUILD_USERNAME=izano
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
lunch havoc_whyred-userdebug
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
m bacon
