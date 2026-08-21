# Fixing Git RPC Failed & HTTP/2 Stream Disconnects on Large Repositories

This document explains how to resolve:
`error: RPC failed; curl 92 HTTP/2 stream 5 was not closed cleanly: INTERNAL_ERROR (err 2)`
`fatal: fetch-pack: invalid index-pack output`

---

## 🔍 Root Cause Analysis

Certain prebuilt kernel modules in AOSP (like `kernel/prebuilts/common-modules/virtual-device/5.15/arm64`) are **3.88 GB** in size. When downloading such large repositories over HTTP/2, Git's default buffer limit causes `curl 92` stream resets.

---

## 🛠️ Instant Fix: Increase Git Buffer & Use HTTP/1.1

Run the following commands in **Ubuntu Terminal**:

```bash
# 1. Increase Git POST buffer to 1 GB
git config --global http.postBuffer 1048576000

# 2. Force Git to use stable HTTP/1.1
git config --global http.version HTTP/1.1

# 3. Resume sync
cd /mnt/e/android/aosp
repo sync -c -j4 --force-sync
```

This prevents large 3.88 GB package stream resets and allows `repo sync` to finish smoothly.
