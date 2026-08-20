# Troubleshooting Non-Empty Directory Case Sensitivity & Symlink Errors in WSL2

This document provides exact steps to fix the error:
`Failed to set case sensitive attribute information for file E:\android\aosp, error: 0x00000091 The directory is not empty.`

---

## 🛠️ Complete 3-Step Fix

### STEP 1: Enable Developer Mode in Windows (PowerShell Admin)

Open **Windows PowerShell as Administrator** and run:

```powershell
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d 1
```

---

### STEP 2: Configure WSL2 Drive Mount Options (`case=dir`)

Open **Ubuntu Linux Terminal** and run:

```bash
sudo bash -c 'cat <<EOF > /etc/wsl.conf
[automount]
enabled = true
options = "metadata,case=dir,umask=22,fmask=11"
EOF'
```

Then close Ubuntu Terminal, open **Windows PowerShell**, and restart WSL2:

```powershell
wsl --shutdown
```

---

### STEP 3: Clean Corrupted BUILD & Resume Sync (Ubuntu Terminal)

Re-open **Ubuntu Linux Terminal** and run:

```bash
cd /mnt/e/android/aosp
rm -rf BUILD build/bazel
repo sync -c -j4 --force-sync
```
