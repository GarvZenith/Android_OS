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

## 2. Installing Google `repo` Tool & Source Code Syncing

### Step 2.1: Install Google `repo` Tool
```bash
# Create bin directory in your home folder
mkdir -p ~/bin
export PATH=~/bin:$PATH

# Download repo launcher script
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+rx ~/bin/repo
```

### Step 2.2: Configure Git Identity
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 2.3: Initialize AOSP Source Tree
```bash
# Create working directory for source tree
mkdir -p ~/aosp
cd ~/aosp

# Initialize AOSP repository (Official AOSP Android 14 branch)
repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r17 --depth=1

# (OR for LineageOS base):
# repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
```

### Step 2.4: Sync (Download) Source Code
```bash
# Download source code using parallel threads (8 threads)
repo sync -c -j8 --no-clone-bundle --no-tags
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
