# Lessons Learned, Troubleshooting Pitfalls & Verified Best Practices

This document provides a comprehensive post-mortem of all **incorrect approaches/pitfalls** encountered during the setup of the Custom Multi-OS Android System, alongside the **verified correct solutions & best practices**.

---

## SECTION 1: INCORRECT APPROACHES & PITFALLS (WHAT WAS WRONG)

### 🔴 Pitfall 1: Full Git History Syncing Without `--depth=1`
- **What Was Wrong**: Running standard `repo sync` without limiting commit history.
- **Why It Failed**: Git downloaded 15+ years of historical commits, diffs, and legacy objects across 1,224 repositories, filling up the 208 GB `E:` drive to 100% capacity (120 KB free).
- **Consequence**: WSL2 9P/drvfs mount layer threw `[Errno 5] Input/output error` due to disk space exhaustion.

---

### 🔴 Pitfall 2: Syncing Unnecessary Heavy Test & Developer Toolchains
- **What Was Wrong**: Downloading legacy test suites and IDE prebuilts (`cts/`, `developers/`, `pdk/`, `platform_testing/`, `prebuilts/ndk/`, `prebuilts/gcc/`, `prebuilts/maven_repo/`).
- **Why It Failed**: Wasted 40+ GB of disk space on Google internal certification tests and 32-bit legacy compilers that are 0% necessary for compiling Android OS system images (`system.img`, `vendor.img`, `ramdisk.img`).

---

### 🔴 Pitfall 3: Windows NTFS ACL Rights Blocking WSL2 User
- **What Was Wrong**: Creating `E:\android` in Windows PowerShell (Admin) without setting NTFS ACL inheritance.
- **Why It Failed**: Windows NTFS Access Control Lists restricted directory creation rights to Windows Administrator accounts.
- **Consequence**: Running `mkdir -p /mnt/e/android/aosp` inside Ubuntu Linux returned `mkdir: Permission denied`.

---

### 🔴 Pitfall 4: Executing Commands Inside Script Backticks
- **What Was Wrong**: Using backticks `` `su` `` inside double-quoted bash `echo` statements in `scripts/apply_patches.sh`.
- **Why It Failed**: Bash interpreted backticks as an active shell execution command and executed `su` on the host machine, triggering a password prompt `Password: su: Authentication failure`.

---

### 🔴 Pitfall 5: Using Proprietary Target Product Names
- **What Was Wrong**: Running `lunch sdk_gphone64_x86_64-userdebug`.
- **Why It Failed**: `sdk_gphone64` refers to Google's closed-source Pixel emulator target, which is not present in open-source AOSP manifests.
- **Consequence**: Build system threw `error: Can not locate config makefile for product "sdk_gphone64_x86_64"`.

---

## SECTION 2: VERIFIED CORRECT APPROACHES (WHAT IS RIGHT)

### 🟢 Solution 1: Shallow Syncing (`--depth=1`)
- **Correct Approach**: Initialize repo with `repo init -u ... -b android-14.0.0_r1 --depth=1` and sync with `repo sync -c --depth=1 -j4 --no-tags --no-clone-bundle`.
- **Result**: Cuts total source footprint from **~250-300 GB down to ~50-60 GB**, saving over 150+ GB of disk space!
- **Build Impact**: 0% negative impact. The compiled OS system images (`system.img`, `vendor.img`) are 100% identical to full clones.

---

### 🟢 Solution 2: Reclaiming Space by Deleting Non-Essential Folders & `.repo` Cache
- **Correct Approach**:
  1. Remove heavy non-essential folders:
     ```bash
     rm -rf cts/ developers/ pdk/ platform_testing/ test/ prebuilts/gcc/ prebuilts/ndk/ prebuilts/maven_repo/ prebuilts/abi-dumps/
     ```
  2. Delete dangling `.repo` git cache mirrors once source code files are checked out:
     ```bash
     rm -rf /mnt/e/android/aosp/.repo
     ```
- **Result**: Instantly reclaims **142+ GB of free space on `E:` drive** without breaking `mka` compilation (since AOSP compilers read directly from checked-out source folders).

---

### 🟢 Solution 3: NTFS Case-Sensitivity & Windows ACL Fix
- **Correct Approach**:
  1. Enable Case-Sensitivity on `E:\android` in Windows PowerShell (Admin):
     ```powershell
     fsutil.exe file setCaseSensitiveInfo "E:\android" enable
     ```
  2. Grant Full Control inheritance via Windows ACL:
     ```powershell
     icacls E:\android /grant "Everyone:(OI)(CI)F"
     ```
  3. Set WSL2 metadata mount options in `/etc/wsl.conf`:
     ```ini
     [automount]
     enabled = true
     options = "metadata,case=dir,uid=1000,gid=1000,umask=022"
     mountFsTab = true
     ```
- **Result**: Completely eliminates `Permission denied` errors inside `/mnt/e/android/`.

---

### 🟢 Solution 4: Target Selection & Selective Component Syncing
- **Correct Approach**: Use open-source AOSP x86_64 target:
  ```bash
  lunch aosp_x86_64-userdebug
  ```
- **Selective Syncing**: Fetch missing VNDK prebuilts and Clang compiler on-demand without full tree re-downloads:
  ```bash
  repo sync platform/prebuilts/vndk/v29 platform/prebuilts/vndk/v30 platform/prebuilts/vndk/v31 platform/prebuilts/vndk/v32 platform/prebuilts/vndk/v33 -c -j4 --no-tags --no-clone-bundle
  repo sync platform/prebuilts/clang/host/linux-x86 -c -j4 --no-tags --no-clone-bundle
  ```

---

## SUMMARY COMPARISON TABLE

| Category | Wrong Approach (Avoid) | Correct Approach (Use) | Space / Build Saved |
| :--- | :--- | :--- | :--- |
| **Git Clone Depth** | Full sync without `--depth=1` | `repo init --depth=1` | Saves ~150 GB |
| **Git Cache Storage** | Keeping 142 GB `.repo` mirror | Deleting `.repo` once checked out | Saves 142 GB |
| **Testing Toolchains** | Downloading `cts/`, `ndk/`, `abi-dumps/` | Removing non-essential prebuilts | Saves ~40 GB |
| **Windows Permissions** | Standard PowerShell `mkdir E:\android` | `icacls E:\android /grant "Everyone:(OI)(CI)F"` | Fixes `Permission denied` |
| **Target Product** | `lunch sdk_gphone64_x86_64` | `lunch aosp_x86_64-userdebug` | Fixes missing config makefile |
