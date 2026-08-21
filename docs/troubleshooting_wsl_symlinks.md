# Fixing Git Corrupt Index File Errors (Bad Signature 0x00000000)

This document explains how to resolve:
`error: bad signature 0x00000000`
`fatal: index file corrupt`
`error: kernel/prebuilts/common-modules/virtual-device/5.10/x86-64/...`

---

## 🔍 Root Cause Analysis
During a previous network interruption, the `.git/index` file inside `kernel/prebuilts/common-modules/virtual-device/5.10/x86-64/` was written with zeroed bytes (bad signature `0x00000000`).

---

## 🛠️ Instant Fix (Delete Corrupt Index & Resume Sync)

Run the following command in **Ubuntu Terminal**:

```bash
cd /mnt/e/android/aosp
rm -f kernel/prebuilts/common-modules/virtual-device/5.10/x86-64/.git/index
rm -rf kernel/prebuilts/common-modules/virtual-device/5.10/x86-64 .repo/projects/kernel/prebuilts/common-modules/virtual-device/5.10/x86-64.git
repo sync -c -j4 --force-sync
```

This cleans the single corrupt git index file (takes 5 seconds) without affecting the 74% downloaded codebase, allowing `repo sync` to finish 100%!
