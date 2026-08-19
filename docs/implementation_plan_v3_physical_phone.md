# Custom Android OS Development Plan (v3 - Physical Phone ROM Target)

This plan focuses specifically on building a **Custom Android OS ROM (.zip)** designed to be flashed onto a **Physical Smartphone** after repair.

---

## Target Objective

Take an old physical smartphone, compile a custom AOSP / LineageOS based system image patched with:
1. **Unrestricted Developer Tools**: Root access (`su`), relaxed SELinux, signature spoofing, and Frida/SSL pinning bypass.
2. **Native Daily Driver Telephony**: Hardware vendor RIL drivers for SIM calling, SMS, VoLTE, and mobile data.
3. **Pre-baked Google Ecosystem**: MicroG / GApps + Google Play Store integration.
4. **Embedded Multi-OS Containers**:
   - **Winlator (Wine + Box64)** pre-configured to run Windows `.exe` apps.
   - **Termux-X11 + Debian** pre-configured for Linux desktop.
   - **TouchHLE + PWA Bridge** pre-configured for iOS apps/services.

---

## Development Roadmap for Physical Phone

```mermaid
flowchart TD
    Step1[1. Identify Target Phone Model & Device Tree] --> Step2[2. Setup AOSP/LineageOS Build Source Tree]
    Step2 --> Step3[3. Patch Kernel & Framework: Root, SELinux, Signature Spoofing]
    Step3 --> Step4[4. Inject Google Apps, MicroG & Telephony RIL Drivers]
    Step4 --> Step5[5. Bake-in Multi-OS Engines: Winlator, Linux X11, TouchHLE]
    Step5 --> Step6[6. Compile Custom Flashable ROM (.zip / fastboot images)]
    Step6 --> Step7[7. Unlock Bootloader & Flash onto Phone via Recovery/Fastboot]
```

---

## Detailed Execution Steps

### Step 1: Device Codename & Source Tree Setup
- Retrieve target phone brand, model, and device codename (e.g. `beryllium`, `sweet`, `chime`).
- Setup AOSP / LineageOS source tree, device tree repository, vendor blobs, and kernel repository.

### Step 2: Framework & Kernel Modification
- Apply signature spoofing patch to `frameworks/base`.
- Embed `su` binary in `/system/xbin/su` and APatch/Magisk daemon.
- Modify SELinux policy to permissive mode option in developer settings.
- Enable KVM / virtual memory flags in Linux kernel config (`defconfig`).

### Step 3: Ecosystem & Container Integration
- Package MicroG / GApps into `/system/priv-app`.
- Pre-install Winlator runtime dependencies into system data image.
- Pre-install Termux-X11 desktop packages.

### Step 4: ROM Build & Flashing Procedure
- Execute `source build/envsetup.sh` and `lunch <device_codename>-userdebug`.
- Compile flashable zip via `mka bacon` or `make target_files_package`.
- Backup EFS partition on phone and flash custom ROM zip via TWRP / OrangeFox recovery.
