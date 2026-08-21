# Fixing PowerShell Syntax for icacls Permissions

This document provides the exact syntax for `icacls` in Windows PowerShell to avoid `The term 'OI' is not recognized` error.

---

## 🛠️ Corrected Windows PowerShell Admin Command

In PowerShell, parentheses `()` must be enclosed in quotes `"Everyone:(OI)(CI)F"`.

Run in **Windows PowerShell (Run as Administrator)**:

```powershell
icacls "E:\android\aosp" /grant "Everyone:(OI)(CI)F" /T
```

*Output*: `Successfully processed all files.`

---

## 🛠️ Alternative: Windows Command Prompt (cmd)

In standard **cmd.exe (Run as Administrator)**:

```cmd
icacls "E:\android\aosp" /grant Everyone:(OI)(CI)F /T
```

---

## 🚀 Resume Sync in Ubuntu Terminal

Re-open **Ubuntu Linux Terminal** and run:

```bash
cd /mnt/e/android/aosp
rm -rf .repo/manifests .repo/manifests.git .repo/manifest.xml
repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r1
repo sync -c -j4 --force-sync
```
