# Physical Phone Unlocking, TWRP Recovery & ROM Flashing Guide

This step-by-step guide explains how to prepare your physical smartphone (after repair), unlock its bootloader, backup critical partitions, install TWRP / OrangeFox recovery, and flash the **Custom Multi-OS Android System**.

---

## Pre-requisites & Tools Required

On your Windows / Linux host machine, install Android Platform Tools:
- `adb` (Android Debug Bridge)
- `fastboot`

Install drivers for your device brand (Qualcomm USB Drivers, Xiaomi ADB Drivers, Google USB Drivers).

---

## Step 1: Unlocking Bootloader

1. Enable **Developer Options** on your phone (Tap `Settings > About Phone > Build Number` 7 times).
2. Inside `Developer Options`, enable **OEM Unlocking** and **USB Debugging**.
3. Connect phone to PC via USB cable and reboot into Bootloader / Fastboot mode:
   ```bash
   adb reboot bootloader
   ```
4. Verify fastboot connection:
   ```bash
   fastboot devices
   ```
5. Execute bootloader unlock command:
   - For Pixel / OnePlus / Android One:
     ```bash
     fastboot flashing unlock
     ```
   - For Xiaomi / Poco / Redmi: Use official **Mi Unlock Tool** on PC.

> [!CAUTION]
> Unlocking the bootloader will erase all user data on the phone. Ensure data is backed up.

---

## Step 2: Flashing Custom Recovery (TWRP / OrangeFox)

1. Download TWRP or OrangeFox recovery `.img` file matching your device codename.
2. Boot into fastboot mode and flash recovery image:
   ```bash
   fastboot flash recovery twrp-<device_codename>.img
   ```
3. Reboot into TWRP recovery:
   ```bash
   fastboot reboot recovery
   ```
   *(Or press Power + Volume Up buttons simultaneously)*.

---

## Step 3: Critical Partition Backup (EFS & IMEI)

Inside TWRP Recovery:
1. Tap **Backup**.
2. Select **EFS**, **NVDATA**, and **NVRAM** partitions.
3. Save the backup file to your MicroSD card or copy to your PC via ADB:
   ```bash
   adb pull /sdcard/TWRP/BACKUPS ./efs_backup/
   ```
> [!IMPORTANT]
> The EFS partition contains your phone's physical SIM IMEI number and radio calibration data. Keeping a backup ensures your SIM phone calling capabilities can always be restored.

---

## Step 4: Flashing Custom Multi-OS Android ROM

Inside TWRP Recovery:
1. Tap **Wipe > Advanced Wipe**.
2. Select `Dalvik / ART Cache`, `Cache`, `System`, and `Data`. Swipe to wipe.
3. Connect phone to PC and copy compiled ROM `.zip` file:
   ```bash
   adb push MultiOS-Android-v1.0.0-<device_codename>.zip /sdcard/
   ```
4. On TWRP screen, tap **Install**, select `MultiOS-Android-v1.0.0-<device_codename>.zip`, and swipe to flash.
5. Once flashing completes, tap **Reboot System**.

---

## Step 5: Post-Boot First Time Setup

1. **Verify Root Access**: Open terminal or app and run `su`. Grant superuser permission.
2. **Verify Google Play Store**: Log into your Google Account, download test apps.
3. **Verify Windows Container**: Launch Winlator from app drawer, create container, and launch `.exe`.
4. **Verify Linux Subsystem**: Launch Termux-X11 and open XFCE Linux desktop.
