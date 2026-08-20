# Troubleshooting WSL2 Symlinks & Corrupted Repo Cleanup

This document provides exact steps to fix `Cannot symlink ...` errors and clean up corrupted sub-repositories (like `build/bazel`) when syncing AOSP on Windows `E:\` drive mounted inside WSL2.

---

## 🛠️ Step-by-Step Resolution

### Step 1: Create /etc/wsl.conf in Ubuntu Terminal
Run this command in Ubuntu Linux terminal:
```bash
sudo bash -c 'cat <<EOF > /etc/wsl.conf
[automount]
enabled = true
options = "metadata,umask=22,fmask=11"
EOF'
```

### Step 2: Shutdown WSL2 in Windows PowerShell
Close Ubuntu Terminal, open Windows PowerShell and run:
```powershell
wsl --shutdown
```

### Step 3: Remove Corrupted Repositories & Force Sync
Re-open Ubuntu Terminal and run:
```bash
cd /mnt/e/android/aosp
rm -rf build/bazel
repo sync -c -j4 --force-sync
```
