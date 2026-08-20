# Fixing NTFS Case Insensitivity & Symlink Collision in WSL2

This document explains the root cause of the persistent error:
`error: Cannot symlink /mnt/e/android/aosp/BUILD to build/bazel/bazel.BUILD`

---

## 🔍 Root Cause Analysis

AOSP source tree contains two colliding entries at the root directory:
1. `build/` (lowercase directory containing Bazel and build tools)
2. `BUILD` (uppercase symlink pointing to Bazel config)

By default, Windows NTFS filesystems (Drives `C:\`, `E:\`) are **case-insensitive**. Windows treats `build` and `BUILD` as the exact same filename. When WSL2 attempts to create the `BUILD` symlink alongside the existing `build/` directory, NTFS blocks the creation with a symlink collision error.

---

## 🛠️ Complete 2-Step Solution

### STEP 1: Enable NTFS Case Sensitivity on E:\android\aosp (Windows PowerShell)

Open **Windows PowerShell as Administrator** and run:

```powershell
fsutil.exe file setCaseSensitiveInfo "E:\android\aosp" enable
```

*Output should say*: `Case sensitive attribute on directory E:\android\aosp is enabled.`

---

### STEP 2: Clean Bazel and Resume Sync (Ubuntu Terminal)

Open **Ubuntu Terminal** and run:

```bash
cd /mnt/e/android/aosp
rm -rf build/bazel BUILD
repo sync -c -j4 --force-sync
```

This completely resolves the NTFS name collision and allows `repo sync` to finish 100%!
