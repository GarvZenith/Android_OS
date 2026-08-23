# Accessing WSL2 Linux Paths & AOSP Code in Windows File Explorer

This guide explains how to locate and open the Linux home directory (`~`) and `~/aosp` folder directly in Windows File Explorer.

---

## Method 1: Instant Command from WSL2 Terminal (Recommended)

Run this command inside your WSL2 / Ubuntu terminal:

```bash
# Navigate to your AOSP folder
cd ~/aosp

# Open current Linux directory directly in Windows File Explorer
explorer.exe .
```

This will automatically open a Windows File Explorer window inside your `~/aosp` folder!

---

## Method 2: Access via Windows Address Bar or Run Dialog

Press `Win + R` on your keyboard (or click the address bar in File Explorer) and enter one of these paths:

### Modern Windows 11 / Windows 10 (WSL2):
```
\\wsl.localhost\Ubuntu\home\<your-ubuntu-username>\aosp
```

### Legacy Windows Network Path:
```
\\wsl$\Ubuntu\home\<your-ubuntu-username>\aosp
```

*(Replace `<your-ubuntu-username>` with your Linux username)*.

---

## Method 3: Left Navigation Sidebar in File Explorer

1. Open **File Explorer** (`Win + E`).
2. Look at the **Left Sidebar** (Navigation Pane).
3. Scroll down until you see the **Linux** (Tux Penguin) icon.
4. Click **Linux > Ubuntu > home > <your-ubuntu-username> > aosp**.

You can now open, edit, view, or copy AOSP files using VS Code, Notepad++, or any Windows app!
