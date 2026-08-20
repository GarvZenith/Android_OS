# Resolving AOSP Workspace Permissions & Parent Directory Ownership

This document explains how to resolve ownership and permission errors across the entire AOSP workspace on `/mnt/e/android/aosp`.

---

## 🛠️ Full Workspace Permission Fix

Run the following commands in **Ubuntu Terminal**:

```bash
# 1. Reset ownership for the whole AOSP workspace
sudo chown -R garv:garv /mnt/e/android/aosp

# 2. Grant full read/write permissions
sudo chmod -R 777 /mnt/e/android/aosp

# 3. Resume sync
cd /mnt/e/android/aosp
repo sync -c -j4 --force-sync
```
