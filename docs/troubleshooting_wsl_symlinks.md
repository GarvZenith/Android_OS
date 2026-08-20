# Troubleshooting WSL2 NTFS Symlinks & Repo Sync Errors

This document explains how to resolve the **Symlink Error** (`Cannot symlink ...`) and **DNS/Network Error** (`Could not resolve host`) when syncing AOSP on a mounted Windows drive (`/mnt/e/android/aosp`).

---

## 🛠️ FIX 1: Enable Linux Symlink & Metadata Support on E:\ Drive

By default, mounted Windows drives (`/mnt/e/`) inside WSL2 block Linux symlinks unless `metadata` options are enabled in `/etc/wsl.conf`.

### Step-by-Step Fix:

1. Open your **Ubuntu Linux Terminal** and run:
   ```bash
   sudo bash -c 'cat <<EOF > /etc/wsl.conf
   [automount]
   enabled = true
   options = "metadata,umask=22,fmask=11"
   EOF'
   ```

2. Close the Ubuntu Terminal.

3. Open **Windows PowerShell** (Run as Administrator) and restart WSL2:
   ```powershell
   wsl --shutdown
   ```

4. Re-open **Ubuntu Linux Terminal** (or type `wsl` in PowerShell).

---

## 🛠️ FIX 2: Resume & Force Repo Sync

Now return to your source code directory and resume the sync:

```bash
cd /mnt/e/android/aosp
repo sync -c -j4 --fail-fast --force-sync
```

This will fix the symlinks and resume downloading the remaining repositories smoothly!
