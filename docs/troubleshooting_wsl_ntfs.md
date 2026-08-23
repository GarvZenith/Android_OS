# Troubleshooting WSL2 NTFS Permissions & I/O Sync Error Guide

This document records the issues, root causes, and verified solutions for WSL2 NTFS drive setups during AOSP compilation.

---

## ISSUE 1: `mkdir: Permission denied` on `/mnt/e/android`

### Root Cause
Windows NTFS Access Control Lists (ACLs) restricted container creation rights to Administrator accounts, blocking the WSL2 non-root user (`garv`) from creating subdirectories on the NTFS mount point.

### Verified Solution
Run in **Windows PowerShell (Admin)**:
```powershell
icacls E:\android /grant "Everyone:(OI)(CI)F"
fsutil.exe file setCaseSensitiveInfo "E:\android" enable
```

---

## ISSUE 2: `[Errno 5] Input/output error` During `repo sync`

### Problem Description
During `repo sync`, fetching massive prebuilt toolchains like `platform/prebuilts/clang/host/linux-x86` (62.61 GiB) fails with:
```text
fatal: write error: Input/output error
fatal: fetch-pack: invalid index-pack output
RepoUnhandledExceptionError: [Errno 5] Input/output error
```

### Root Cause
- `platform/prebuilts/clang/host/linux-x86` contains giant git packfiles (62+ GiB).
- Streaming massive git packs over WSL2's 9P/drvfs mount layer onto an NTFS drive causes git buffer allocation timeouts and file handle exhaustion in WSL2 I/O subsystem.

### Verified Solution

#### 1. Configure Git Pack & Memory Buffers
Run in **Ubuntu Linux Terminal**:
```bash
git config --global core.packedGitLimit 512m
git config --global core.packedGitWindowSize 512m
git config --global pack.deltaCacheSize 512m
git config --global pack.packSizeLimit 2g
git config --global pack.threads 4
```

#### 2. Resume `repo sync` with Low Parallel Job Count
Run in **Ubuntu Linux Terminal**:
```bash
cd /mnt/e/android/aosp
repo sync -c -j2 --fail-fast --no-tags --no-clone-bundle
```
*Why this works*: `repo` automatically resumes from 99% progress. Reducing job threads (`-j2`) prevents disk I/O congestion and completes downloading large prebuilts safely.
