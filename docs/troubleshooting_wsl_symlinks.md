# Resolving NotADirectoryError: [Errno 20] on build/ Subdirectories

This document explains how to resolve:
`error: Cannot checkout platform/build/... NotADirectoryError: [Errno 20] Not a directory: '/mnt/e/android/aosp/build/...'`

---

## 🔍 Root Cause Analysis
During an earlier step, a file named `build` was created instead of a directory. When `repo sync` attempts to checkout submodules inside `build/` (like `build/make`, `build/soong`, `build/bazel`), Linux returns `Not a directory`.

---

## 🛠️ Instant Fix

Run the following command in **Ubuntu Terminal**:

```bash
cd /mnt/e/android/aosp
rm -rf build BUILD
mkdir -p build
repo sync -c -l --no-tags --force-sync
```

This removes the file collision, creates `build/` as a proper directory, and completes the local checkout cleanly!
