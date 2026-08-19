# Physical Smartphone Custom ROM Setup Checklist

Follow this checklist to prepare your phone for compiling and flashing the **Custom Multi-OS Android ROM**.

---

## Required Phone Details

To build the custom ROM specifically for your physical phone, we need the following details:

1. **Brand & Exact Model**: (e.g., Xiaomi Redmi Note 10 Pro, Poco F1, OnePlus 7T, Google Pixel 4a, etc.)
2. **Device Codename**: (e.g., `sweet`, `beryllium`, `hotdogb`, `sunfish`). *You can check this using the CPU-Z app or looking up your phone on AIDA64 / GSMarena.*
3. **Processor / Chipset**: (e.g., Snapdragon 732G, Snapdragon 845, MediaTek Dimensity 1200, Exynos 990).
4. **RAM & Internal Storage**: (e.g., 6 GB RAM / 128 GB Storage).

---

## Phone Preparation Steps (After Repairing)

### Step 1: Unlock Bootloader
- **Xiaomi/Poco/Redmi**: Unlock via Mi Unlock Tool.
- **OnePlus / Google Pixel / Motorola**: Unlock via `fastboot flashing unlock` or `fastboot oem unlock`.
- **Realme**: Unlock via official Deep Testing APK.

### Step 2: Install Custom Recovery
- Install **TWRP** or **OrangeFox Recovery** compiled for your device codename.
- This allows flashing custom OS `.zip` packages, backing up partitions (`EFS`, `NVDATA`, `System`), and wiping data safely.

### Step 3: Backup Critical Partitions
- Take a full TWRP backup of the **EFS** partition (which contains your phone's IMEI number, SIM RIL configuration, and MAC address) so your SIM calling features are never lost.

---

## What We Will Build in this Project
1. **Custom Framework & Kernel Patches**: Integrating root (`su`), signature spoofing, permissive SELinux, and SSL Pinning bypass modules into the ROM source code.
2. **Pre-baked Ecosystem Modules**:
   - Google Play Services / MicroG & Play Store.
   - Winlator / Wine + Box64 Windows Container pre-installed into `/system/app`.
   - Termux-X11 Linux Subsystem pre-configured.
   - TouchHLE iOS Runtime engine pre-configured.
3. **Flashable Custom ROM Package (.zip)**: Generating a flashable zip image specifically tailored for your phone model.
