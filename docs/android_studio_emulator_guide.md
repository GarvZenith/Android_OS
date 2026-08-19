# Android Studio Emulator Custom OS Setup & Testing Guide

This guide explains step-by-step how to load, run, and test your **Custom Multi-OS Android System** inside **Android Studio Emulator**.

---

## 1. Setting Up Custom System Image in Android Studio

Once your custom OS images (`system.img`, `vendor.img`, `ramdisk.img`) are built:

1. Locate your Android Studio SDK directory:
   - Windows: `C:\Users\<username>\AppData\Local\Android\Sdk\`
   - Linux: `~/Android/Sdk/`

2. Create a custom system image directory:
   ```bash
   mkdir -p ~/Android/Sdk/system-images/android-34/custom_multi_os/x86_64/
   ```

3. Copy your compiled images into this folder:
   ```bash
   cp system.img vendor.img ramdisk.img kernel-ranchu ~/Android/Sdk/system-images/android-34/custom_multi_os/x86_64/
   ```

4. Add a `source.properties` file:
   ```ini
   Pkg.Revision=1
   Pkg.Desc=Custom Multi-OS Android System Image
   SystemImage.Abi=x86_64
   SystemImage.TagId=default
   AndroidVersion.ApiLevel=34
   ```

---

## 2. Creating the Virtual Device in Android Studio

1. Open **Android Studio**.
2. Click **Tools > Device Manager** (or AVD Manager).
3. Click **Create Virtual Device**.
4. Select a device profile (e.g. **Pixel 7** or **Phone - Medium Phone**).
5. On the **System Image** selection screen, click the **Other Images** tab.
6. Select **Custom Multi-OS Android System Image** (API 34, x86_64).
7. Set RAM to **4096 MB** or **8192 MB** and Internal Storage to **32 GB**.
8. Click **Finish**.

---

## 3. Testing Features in Android Studio Emulator

### A. Unrestricted Root & Developer Testing
Open terminal on host machine and connect to running emulator:
```bash
adb root
adb shell
# Check root permission
su
# Check SELinux mode
getenforce
```

### B. Testing Phone Calls & Telephony
In Android Studio Emulator:
1. Click the **3 dots (...)** icon on the emulator sidebar to open **Extended Controls**.
2. Go to **Phone** tab.
3. Type any phone number (e.g. `+15555555555`) and click **Call Device**.
4. Test incoming call UI, answering, and voice audio.

### C. Testing Windows (.exe) & Linux Containers
Launch Winlator or Termux-X11 inside the emulator:
- Since Android Studio Emulator runs natively on your PC's x86_64 CPU, Windows `.exe` apps run with high performance!
