# Resolving Hidden .repo Directory Ownership & Permission Errors

This document explains how to fix:
`PermissionError: [Errno 13] Permission denied: '/mnt/e/android/aosp/.repo/manifests.git'`

---

## 🔍 Root Cause Analysis

Because Linux dot-directories (hidden folders starting with `.`) like `.repo/` are omitted by some wildcard operations, files inside `.repo/manifests.git` retained `root` ownership. When running `repo init` as user `garv`, Linux denied write permissions to create `.repo/manifests.git`.

---

## 🛠️ Complete Permission Reset & Manifest Re-init

Run the following commands in **Ubuntu Terminal**:

```bash
cd /mnt/e/android/aosp

# 1. Reset ownership and permissions specifically on hidden .repo folder
sudo chown -R garv:garv /mnt/e/android/aosp/.repo
sudo chmod -R 777 /mnt/e/android/aosp/.repo

# 2. Clean stale manifests metadata
rm -rf .repo/manifests .repo/manifests.git .repo/manifest.xml

# 3. Re-initialize manifest
repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r1

# 4. Resume sync with existing downloaded source tree
repo sync -c -j4 --force-sync
```
