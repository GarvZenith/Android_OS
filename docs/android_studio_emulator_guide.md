# Android Studio Emulator Setup & Execution Map (Where & How to Run)

This document provides an explicit breakdown of **WHERE** (Linux terminal, Windows CMD, Android Studio GUI) and **HOW** to execute each step of building and running the Custom Multi-OS Android System inside Android Studio Emulator.

---

## Environment & Tool Execution Map

```
+-----------------------------------------------------------------------------------+
| STEP 1: Build System Image                                                        |
| WHERE: Linux Terminal (Ubuntu / WSL2)                                             |
| COMMANDS: source build/envsetup.sh -> lunch sdk_gphone64_x86_64-userdebug -> mka  |
+-----------------------------------------------------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
| STEP 2: Deploy Images to Windows SDK                                              |
| WHERE: Windows Command Prompt (cmd.exe) / File Explorer                           |
| PATH: C:\Users\<Username>\AppData\Local\Android\Sdk\system-images\...             |
+-----------------------------------------------------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
| STEP 3: Create AVD in Android Studio                                              |
| WHERE: Android Studio GUI -> Tools > Device Manager > Other Images                |
+-----------------------------------------------------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
| STEP 4: Run & Test Custom OS                                                      |
| WHERE: Emulator GUI + Windows CMD (adb root / su / Extended Controls)             |
+-----------------------------------------------------------------------------------+
```

---

## Detailed Step-by-Step Execution Guide

### STEP 1: System Image Compilation
- **Where to Run**: **Ubuntu Linux Terminal** (or WSL2 Linux terminal on Windows).
- **Why**: Android AOSP source code must be compiled in a Linux environment with case-sensitive filesystem support.
- **Commands to Run**:
  ```bash
  cd ~/aosp
  source build/envsetup.sh
  lunch sdk_gphone64_x86_64-userdebug
  mka -j$(nproc)
  ```
- **Output Generated**: `out/target/product/emulator_x86_64/` containing:
  - `system.img`
  - `vendor.img`
  - `ramdisk.img`
  - `kernel-ranchu`

---

### STEP 2: Custom Images Setup in Windows SDK
- **Where to Run**: **Windows Command Prompt (cmd)** or **PowerShell**.
- **Commands to Run**:
  ```cmd
  mkdir "C:\Users\Garv\AppData\Local\Android\Sdk\system-images\android-34\custom_multi_os\x86_64"
  ```
- **File Transfer**: Copy the 4 generated files (`system.img`, `vendor.img`, `ramdisk.img`, `kernel-ranchu`) from your Linux environment into this newly created Windows folder.
- **Create Property File**: Create a file named `source.properties` inside that folder with the following content:
  ```ini
  Pkg.Revision=1
  Pkg.Desc=Custom Multi-OS Android System Image
  SystemImage.Abi=x86_64
  SystemImage.TagId=default
  AndroidVersion.ApiLevel=34
  ```

---

### STEP 3: Create Virtual Device (AVD) in Android Studio GUI
- **Where to Run**: **Android Studio GUI application** on Windows.
- **Steps**:
  1. Launch **Android Studio**.
  2. Navigate to **Tools > Device Manager** from the top menu.
  3. Click **Create Virtual Device** (`+` button).
  4. Select Hardware profile: **Pixel 7** or **Medium Phone** -> Click **Next**.
  5. On System Image Selection: Click the **Other Images** tab.
  6. Select **Custom Multi-OS Android System Image** -> Click **Next**.
  7. Configure RAM (**4096 MB** or **8192 MB**) and Storage (**32 GB**) -> Click **Finish**.

---

### STEP 4: Launching & Testing the Custom OS
- **Where to Run**: **Android Studio Emulator Window** + **Windows CMD** (for ADB commands).
- **Steps**:
  1. Click the **Play (▶)** button in Device Manager to start the emulator.
  2. Open Windows CMD to test root and security hooks:
     ```cmd
     adb root
     adb shell
     su
     getenforce
     ```
  3. **Test Virtual SIM Calling**: Click the **Extended Controls (...)** icon on the emulator toolbar -> Go to **Phone** tab -> Type number `+15555555555` -> Click **Call Device**.
  4. **Test Multi-OS Apps**: Open pre-installed **Winlator** for Windows `.exe` apps or **Termux-X11** for Linux desktop environment directly on the emulator home screen.
