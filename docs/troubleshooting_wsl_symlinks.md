# Resolving WSL2 Permission Denied (Errno 13) on Mounted Drives

This document explains how to resolve `PermissionError: [Errno 13] Permission denied: '/mnt/e/android/aosp/build'`.

---

## 🔍 Root Cause Analysis

When running `repo sync` under WSL2 without initial metadata options, certain directories (like `/mnt/e/android/aosp/build`) get assigned read-only Windows file locks or root ownership. When `repo sync` tries to checkout or modify files inside `build`, it receives a `Permission denied` error.

---

## 🛠️ Instant Permission Fix

Run the following commands in **Ubuntu Terminal**:

```bash
# 1. Reset ownership to user garv
sudo chown -R garv:garv /mnt/e/android/aosp/build

# 2. Grant full read/write/execute permissions
sudo chmod -R 777 /mnt/e/android/aosp/build

# 3. Remove lock files and resume sync
sudo rm -rf /mnt/e/android/aosp/BUILD /mnt/e/android/aosp/build/bazel
cd /mnt/e/android/aosp
repo sync -c -j4 --force-sync
```
