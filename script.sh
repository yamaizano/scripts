#!/bin/bash

rm -rf .repo/local_manifests/

# Local TimeZone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Rom source repo
repo init -u https://github.com/DotOS/manifest.git -b dot11
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
git clone -b dotos https://github.com/yamaizano/local_manifests .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
rm -r external/perfetto
rm -r external/chromium-webview

/opt/crave/resync.sh

git clone -b android-11.0.0_r48 --depth=1 https://android.googlesource.com/platform/external/chromium-webview external/chromium-webview
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
lunch dot_whyred-userdebug
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
m bacon
