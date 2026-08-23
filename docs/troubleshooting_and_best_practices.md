# Master Troubleshooting, Post-Mortem & Best Practices Guide

This master document records all **issues encountered, root cause analyses, verified solutions, pitfalls to avoid, and best practices** for building and compiling the Custom Multi-OS Android System on Windows WSL2.

---

## SECTION 1: WSL2 & NTFS DRIVE TROUBLESHOOTING

### 1. `mkdir: Permission denied` on `/mnt/e/android`

#### Problem Description
Attempting to create subdirectories inside Ubuntu WSL2 returned:
```bash
garv@DESKTOP-1T0HST1:/mnt/e/android$ mkdir -p aosp
mkdir: Permission denied
```
Even after running `chown` or `chmod` inside Linux, directory creation failed.

#### Root Cause
The `E:\android` directory was initially created using Windows PowerShell as Administrator. Windows NTFS Access Control Lists (ACLs) restricted container creation rights to Administrator accounts, blocking the WSL2 non-root user (`garv`) from creating subdirectories on the NTFS mount point.

#### Verified Solution
1. Run in **Windows PowerShell (Admin)**:
   ```powershell
   icacls E:\android /grant "Everyone:(OI)(CI)F"
   fsutil.exe file setCaseSensitiveInfo "E:\android" enable
   ```
2. Configure WSL2 mount metadata in Ubuntu Linux (`/etc/wsl.conf`):
   ```ini
   [automount]
   enabled = true
   options = "metadata,case=dir,uid=1000,gid=1000,umask=022"
   mountFsTab = true
   ```
3. Restart WSL2 in PowerShell (Admin): `wsl --shutdown`

---

### 2. `[Errno 5] Input/output error` During `repo sync`

#### Problem Description
During `repo sync`, fetching massive prebuilt toolchains like `platform/prebuilts/clang/host/linux-x86` (62.61 GiB) failed with:
```text
fatal: write error: Input/output error
fatal: fetch-pack: invalid index-pack output
RepoUnhandledExceptionError: [Errno 5] Input/output error
```

#### Root Cause
- `platform/prebuilts/clang/host/linux-x86` contains giant git packfiles (62+ GiB).
- Streaming massive git packs over WSL2's 9P/drvfs mount layer onto an NTFS drive causes git buffer allocation timeouts and file handle exhaustion in WSL2 I/O subsystem.
- Also, `E:` drive physically ran out of disk space (0 KB free) because full git commit history took 180+ GB inside `.repo`.

#### Verified Solution
1. Set Git Pack & Memory Buffers in Ubuntu Linux Terminal:
   ```bash
   git config --global core.packedGitLimit 512m
   git config --global core.packedGitWindowSize 512m
   git config --global pack.deltaCacheSize 512m
   git config --global pack.packSizeLimit 2g
   git config --global pack.threads 4
   ```
2. Delete dangling `.repo` git cache (142 GB) once source files are checked out:
   ```bash
   rm -rf /mnt/e/android/aosp/.repo
   ```
3. Re-init repo with `--depth=1`:
   ```bash
   repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r1 --depth=1
   ```
4. Selective sync with low parallel job count:
   ```bash
   repo sync platform/prebuilts/clang/host/linux-x86 -c -j4 --no-tags --no-clone-bundle
   ```

---

### 3. `untracked working tree files would be overwritten by checkout`

#### Problem Description
When running `repo sync`, git aborted checkout in `system/libhidl`, `hardware/interfaces`, or `prebuilts/rust`:
```text
error: The following untracked working tree files would be overwritten by checkout:
Please move or remove them before you switch branches. Aborting.
```

#### Root Cause
Previous interrupted build/sync attempts left loose untracked files in those directories. Git safely aborts checkout to prevent overwriting uncommitted files.

#### Verified Solution
Delete the dirty local directories so `repo` can perform a 100% clean checkout:
```bash
rm -rf /mnt/e/android/aosp/system/libhidl /mnt/e/android/aosp/hardware/interfaces /mnt/e/android/aosp/prebuilts/rust
repo sync platform/hardware/interfaces platform/system/hardware/interfaces platform/system/libhidl platform/prebuilts/rust -c -j4 --no-tags --no-clone-bundle
```

---

## SECTION 2: SOONG BUILD SYSTEM & UNDEFINED MODULE RESOLUTIONS

### 1. `Can not locate config makefile for product "sdk_gphone64_x86_64"`
- **Root Cause**: `sdk_gphone64` refers to Google's proprietary Pixel emulator target.
- **Solution**: Use the open-source AOSP x86_64 target:
  ```bash
  lunch aosp_x86_64-userdebug
  ```

---

### 2. `error: VNDK version 29 not found`
- **Root Cause**: `prebuilts/vndk/v29` vendor compatibility prebuilt library was missing from the tree.
- **Solution**: Selectively sync VNDK prebuilt libraries:
  ```bash
  repo sync platform/prebuilts/vndk/v29 platform/prebuilts/vndk/v30 platform/prebuilts/vndk/v31 platform/prebuilts/vndk/v32 platform/prebuilts/vndk/v33 -c -j4 --no-tags --no-clone-bundle
  ```

---

### 3. `undefined module "cts_defaults"` / `csuite_test` / `bpf_defaults` / `tradefed_defaults`
- **Root Cause**: Non-essential test/framework repos were missing or cleaned, but remaining test files in `packages/modules/` imported their definitions.
- **Solution**: Selectively sync the lightweight text definition repos (~50-100 MB total):
  ```bash
  repo sync platform/cts platform/sdk platform/prebuilts/sdk platform/system/bpf platform/system/extras platform/tools/tradefederation platform/hardware/interfaces platform/system/hardware/interfaces platform/system/libhidl platform/prebuilts/rust -c -j4 --no-tags --no-clone-bundle
  ```

---

### 4. RAM Constraint Warnings (`You are building on a machine with 7.36GB of RAM`)
- **Root Cause**: Machine has 7.36 GB RAM available in WSL2. High parallel jobs (`-j8` / `-j16`) can cause RAM exhaustion or segfaults.
- **Solution**: Use `-j2` thread optimization for building:
  ```bash
  m systemimage vendorimage ramdisk -j2
  ```

---

## SECTION 3: PITFALLS & VERIFIED BEST PRACTICES SUMMARY

| Category | Wrong Approach (Avoid) | Correct Approach (Use) | Space / Build Impact |
| :--- | :--- | :--- | :--- |
| **Git Clone Depth** | Full sync without `--depth=1` | `repo init --depth=1` | Saves ~150 GB |
| **Git Cache Storage** | Keeping 142 GB `.repo` mirror | Deleting `.repo` once checked out | Saves 142 GB |
| **Testing Toolchains** | Downloading `cts/`, `ndk/`, `abi-dumps/` | Removing non-essential prebuilts | Saves ~40 GB |
| **Windows Permissions** | Standard PowerShell `mkdir E:\android` | `icacls E:\android /grant "Everyone:(OI)(CI)F"` | Fixes `Permission denied` |
| **Target Product** | `lunch sdk_gphone64_x86_64` | `lunch aosp_x86_64-userdebug` | Fixes missing config makefile |
| **Soong Missing Modules** | Re-downloading full 250 GB tree | Selective sync of target interface repos | Saves time & 200 GB |
