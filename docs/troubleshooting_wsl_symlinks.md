# Fixing Corrupted Repo Manifest Git Locks

This document explains how to reset `.repo/manifests.git` without deleting the 100GB downloaded source code repository.

---

## 🔍 Why Resetting Manifest Metadata Fixes the Ref Lock

The manifest git repository (`.repo/manifests.git`) holds project mapping metadata (~2 MB). If its `packed-refs` or git refs get corrupted during an interrupted sync, Git fails to create `refs/remotes/m/`.

Resetting `.repo/manifests.git` re-downloads the 2 MB manifest without touching the 100GB of pre-downloaded source objects in `.repo/project-objects/`.

---

## 🛠️ Instant 3-Step Fix

Run the following commands in **Ubuntu Terminal**:

```bash
cd /mnt/e/android/aosp

# 1. Clean corrupted manifest metadata (Does NOT touch 100GB source code)
rm -rf .repo/manifests .repo/manifests.git .repo/manifest.xml

# 2. Re-initialize manifest (Takes 3 seconds)
repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r1

# 3. Resume sync with existing 100GB source tree
repo sync -c -j4 --force-sync
```
