# Storage Optimization & Local Checkout Guide (Saving 40+ GB)

This document explains how to free **30-40 GB** of disk space on Drive `E:\` and complete `repo sync` locally using existing data without re-downloading large physical ARM64 kernel blobs.

---

## 🔍 Why E:\ Drive Filled Up

1. **Unneeded ARM64 Prebuilt Kernels**: The AOSP manifest includes `kernel/prebuilts/5.10/arm64` (**20.79 GB**) and `kernel/prebuilts/5.15/arm64` (**3.88 GB**). These are for physical ARM64 phones and are **NOT used** by the x86_64 Android Studio Emulator.
2. **Double Storage**: AOSP keeps git compressed objects in `.repo/` and uncompressed files in working tree.

---

## 🛠️ Instant 3-Step Space Cleanup & Local Checkout

Run the following commands in **Ubuntu Terminal**:

```bash
cd /mnt/e/android/aosp

# 1. Delete unnecessary ARM64 kernel prebuilts (Instantly frees 30-40 GB on E:\)
rm -rf kernel/prebuilts/*/arm64 .repo/projects/kernel/prebuilts/*/arm64.git .repo/project-objects/kernel/prebuilts/*/arm64.git

# 2. Fix root BUILD symlink
echo "build/bazel/bazel.BUILD" > BUILD

# 3. Perform LOCAL sync (-l flag skips network downloads & finishes using local files)
repo sync -c -l --no-tags --force-sync
```

Using the `-l` flag forces `repo` to perform checkout locally from already-downloaded 100GB objects without downloading any 21GB network packages!
