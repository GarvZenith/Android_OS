# Developer & Compilation Guide

This guide provides instructions for building, patching, and modifying the **Custom Multi-OS Android System**.

---

## 1. Prerequisites & Host Build Machine Setup

### Required OS & Hardware
- **Host System**: Ubuntu 22.04 LTS (Native or Windows 11 WSL2)
- **RAM**: 32 GB RAM minimum
- **Disk Space**: 300 GB NVMe SSD space minimum

### Installing Build Dependencies
```bash
sudo apt update && sudo apt install -y \
    git-core gnupg flex bison build-essential zip curl zlib1g-dev \
    gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev \
    x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
    libxml2-utils xsltproc unzip fontconfig openjdk-17-jdk python3 \
    rsync schedtool ccache libssl-dev
```

---

## 2. Source Code Syncing

```bash
# Create directory for source tree
mkdir -p ~/aosp
cd ~/aosp

# Initialize repository (using LineageOS / AOSP manifest)
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs

# Sync source tree (using 8 parallel threads)
repo sync -c -j8 --force-sync --no-clone-bundle
```

---

## 3. Applying Framework & Security Patches

### A. Signature Spoofing Patch
Apply signature spoofing patch to allow MicroG and unsigned app testing:
```bash
cd ~/aosp/frameworks/base
git apply /path/to/signature_spoofing.patch
```

### B. Embedding Root Binary (`su`)
Ensure root binary is included in system build flags:
```bash
# In device configuration file (BoardConfig.mk)
WITH_SU := true
SELINUX_IGNORE_NEVERALLOWS := true
```

---

## 4. Pre-Baking Containers (Windows, Linux, iOS)

### Including Winlator (Windows Container)
Place pre-built Winlator APK into `vendor/extra/packages/Winlator/Winlator.apk` and define `Android.mk`:
```makefile
include $(CLEAR_VARS)
LOCAL_MODULE := Winlator
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := Winlator.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)
```

---

## 5. Compiling the Custom ROM

```bash
# Set up environment variables
source build/envsetup.sh

# Select target lunch combo
lunch lineage_<device_codename>-userdebug

# Start compilation
mka bacon -j$(nproc)
```

The output flashable ROM zip will be generated at:
`out/target/product/<device_codename>/lineage-20.0-XXXXX-<device_codename>.zip`
