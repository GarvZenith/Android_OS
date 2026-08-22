# Troubleshooting WSL2 NTFS Permissions & Directory Creation Guide

This document records the exact issue, root cause analysis, and verified commands used to resolve the `Permission denied` error when setting up **`E:\android`** on Windows WSL2 for AOSP source compilation.

---

## 🚨 Problem Encountered

When attempting to create the AOSP source directory inside Ubuntu WSL2:
```bash
garv@DESKTOP-1T0HST1:/mnt/e/android$ mkdir -p aosp
mkdir: Permission denied
```
Even after setting `chown` and `chmod` inside Linux, directory creation returned `Permission denied`.

---

## 🔍 Root Cause Analysis

- **Windows NTFS ACL Override**: The `E:\android` directory was initially created using Windows PowerShell as Administrator (`mkdir E:\android`).
- Windows NTFS Access Control Lists (ACLs) restricted container creation rights to Administrator accounts, blocking the WSL2 non-root user (`garv`) from creating subdirectories on the NTFS mount point.

---

## ✅ Verified Solution & Commands Used

### Step 1: Grant Full Inherited Permissions via Windows ACL (`icacls`)
Run in **Windows PowerShell (Admin)**:
```powershell
icacls E:\android /grant "Everyone:(OI)(CI)F"
```

#### Command Breakdown:
- `icacls E:\android`: Modifies Access Control Lists for the `E:\android` directory.
- `/grant "Everyone"`: Applies permissions to all system users and WSL2 instances.
- `(OI)`: **Object Inherit** - Files created inside will inherit these permissions.
- `(CI)`: **Container Inherit** - Subdirectories created inside will inherit these permissions.
- `(F)`: **Full Control** - Enables read, write, execute, delete, and directory creation.

---

### Step 2: Enable NTFS Case-Sensitivity (`fsutil`)
Run in **Windows PowerShell (Admin)**:
```powershell
fsutil.exe file setCaseSensitiveInfo "E:\android" enable
```

---

### Step 3: Configure WSL2 Mount Metadata (`/etc/wsl.conf`)
Run in **Ubuntu Linux Terminal**:
```bash
sudo printf '[automount]\nenabled = true\noptions = "metadata,case=dir,uid=1000,gid=1000,umask=022"\nmountFsTab = true\n' | sudo tee /etc/wsl.conf
```

---

### Step 4: Restart WSL2 Instance
Run in **Windows PowerShell (Admin)**:
```powershell
wsl --shutdown
```

---

### Step 5: Successful Directory Creation & Permission Verification
Run in **Ubuntu Linux Terminal**:
```bash
cd /mnt/e/android
mkdir -p aosp
cd aosp
```

#### Verification Result:
- `E:\android\aosp` (`/mnt/e/android/aosp`) created successfully without any permission errors!
