# Fixing Git RPC Disconnects on Massive 20.79 GB Prebuilt Kernel Repositories

This document explains how to handle large kernel prebuilt blobs (like `kernel/prebuilts/5.10/arm64` at 20.79 GB) during AOSP repo sync.

---

## 🔍 Root Cause Analysis

AOSP contains large prebuilt binaries including `kernel/prebuilts/5.10/arm64` (**20.79 GB**). Git's default buffer limit causes `curl 92 HTTP/2 stream` RPC errors during such massive downloads.

---

## 🛠️ Instant Solution

Run the following commands in **Ubuntu Terminal**:

```bash
# 1. Increase Git POST buffer to 2 GB
git config --global http.postBuffer 2147483648

# 2. Force Git to use stable HTTP/1.1
git config --global http.version HTTP/1.1

# 3. Resume sync with 2 threads for maximum stability
cd /mnt/e/android/aosp
repo sync -c -j2 --force-sync
```
