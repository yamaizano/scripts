#!/bin/bash

rm -rf .repo/local_manifests/

# Local TimeZone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Rom source repo
repo init -u https://github.com/LineageOS/android.git -b lineage-19.1 --git-lfs
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
git clone -b LOS19.1 https://github.com/yamaizano/local_manifests .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync the repositories
rm -rf prebuilts/clang/host/linux-x86
rm -rf prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9
rm -r external/adeb
rm -r external/chromium-libpac
rm -r external/chromium-webview
rm -r external/honggfuzz
rm -r external/jemalloc
rm -r external/libdaemon
rm -r external/libunwind
rm -r external/libunwind_llvm
rm -r external/libvterm
rm -r external/nfacct
rm -r external/tinyxml
rm -r external/u-boot
rm -r external/v8
rm -r frameworks/ml
rm -r hardware/qcom/neuralnetworks/hvxservice
rm -r packages/apps/PermissionController
rm -r packages/apps/Terminal
rm -r packages/modules/IPsec
rm -r prebuilts/vndk/v27
rm -r system/connectivity/wifilogd
rm -r test/suite_harness
rm -r tools/loganalysis
rm -r tools/tradefederation/contrib
rm -r tools/tradefederation/core

/opt/crave/resync.sh

rm -rf hardware/xiaomi
git clone --depth 1 -b lineage-19.1 https://github.com/LineageOS/android_hardware_xiaomi.git hardware/xiaomi
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
lunch lineage_whyred-userdebug
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
m bacon
