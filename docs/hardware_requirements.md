# Storage Optimization & Disk Space Management Guide for AOSP

This document details how to optimize disk space when building AOSP / Custom Android OS on drives with 200 GB or less storage.

---

## 🚨 Storage Bottleneck Analysis

When syncing full AOSP source code without depth limits:
- Full Git Commit History (`.repo/project-objects/`): **~120 GiB**
- Source Code & Prebuilts (`frameworks/`, `prebuilts/`, `system/`): **~80 GiB**
- Build Outputs (`out/target/product/`): **~30-50 GiB**
- **Total Required Storage**: **~250 - 300 GiB**

If `E:` drive is 208 GB, full sync will fill the disk to 100% (0 KB free) and trigger `[Errno 5] Input/output error`.

---

## ✅ Solutions to Fit AOSP in 60 - 80 GiB Space

### Strategy 1: Shallow Clone (`--depth=1`)
Using `--depth=1` tells Git to download **ONLY the current code version** without 15+ years of past commit history.
- **Full Sync**: ~250 GiB
- **Shallow Sync (`--depth=1`)**: ~60 - 80 GiB *(Saves ~150+ GiB!)*

#### How to Convert to Shallow Sync:
Run in **Ubuntu Linux Terminal**:
```bash
cd /mnt/e/android/aosp
repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r1 --depth=1
repo sync -c --depth=1 -j4 --no-tags --no-clone-bundle
```

---

### Strategy 2: Remove Unused Darwin / Mac Prebuilts
AOSP includes prebuilt toolchains for macOS/Darwin which are unnecessary on Linux/Windows.
Run in **Ubuntu Linux Terminal**:
```bash
cd /mnt/e/android/aosp
rm -rf prebuilts/clang/host/darwin-x86/
rm -rf .repo/projects/prebuilts/clang/host/darwin-x86.git/
rm -rf .repo/project-objects/*darwin*
```

---

### Strategy 3: Clean Unused Git Cache (`git gc`)
Run git garbage collection inside `.repo` to immediately reclaim freed space:
```bash
cd /mnt/e/android/aosp
repo forall -c 'git gc --prune=now'
```

---

### Strategy 4: Extend E: Partition in Windows Disk Management
If `C:` (which has 34.4 GB free) and `E:` are on the same physical SSD drive:
1. Press `Win + X` -> Click **Disk Management** (`diskmgmt.msc`).
2. Right-click `C:` volume -> Click **Shrink Volume** (e.g. shrink 20 GB).
3. Right-click `E:` volume -> Click **Extend Volume** to add 20 GB to `E:`.
