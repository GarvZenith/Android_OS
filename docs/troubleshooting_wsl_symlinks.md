# Manually Resetting Permissions via Windows File Explorer & PowerShell

This document explains how to manually grant Full Control permissions on `E:\android\aosp` directly from Windows without waiting for Linux `chown`.

---

## 🛠️ Method 1: Windows File Explorer GUI (Manual Permissions)

1. Open **Windows File Explorer** (`Win + E`) and navigate to `E:\android`.
2. Right-click the **`aosp`** folder -> Click **Properties**.
3. Uncheck **Read-only (Only applies to files in folder)**.
4. Click **Apply** -> Select *"Apply changes to this folder, subfolders and files"* -> Click **OK**.
5. Click the **Security** tab -> Click **Edit**.
6. Select **Users** (or **Everyone**) -> Check **Full control** (Allow).
7. Click **Apply** -> Click **OK**.

---

## 🛠️ Method 2: Windows PowerShell Admin Command (Fastest 5-Second Fix)

Open **Windows PowerShell (Run as Administrator)** and run:

```powershell
icacls "E:\android\aosp" /grant Everyone:(OI)(CI)F /T
```

*Output*: `Successfully processed all files.`

After running either method, re-open **Ubuntu Terminal** and run:

```bash
cd /mnt/e/android/aosp
rm -rf .repo/manifests .repo/manifests.git .repo/manifest.xml
repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r1
repo sync -c -j4 --force-sync
```
