# Fixing BUILD Directory Collision (-bash: BUILD: Is a directory)

This document explains how to resolve `-bash: BUILD: Is a directory` when creating the root `BUILD` file.

---

## 🔍 Cause
An empty directory named `BUILD` was created in an earlier interrupted run. The shell cannot redirect text into a directory object.

---

## 🛠️ Instant Fix

Run the following command in **Ubuntu Terminal**:

```bash
cd /mnt/e/android/aosp
rm -rf BUILD
echo "build/bazel/bazel.BUILD" > BUILD
repo sync -c -l --no-tags --force-sync
```
