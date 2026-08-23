# Custom Multi-OS Android System (Android 14 AOSP)

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Platform: Android 14](https://img.shields.io/badge/Platform-Android_14_AOSP-green.svg)](https://source.android.com)
[![Target: Android Studio Emulator](https://img.shields.io/badge/Target-x86__64_Emulator-orange.svg)](docs/android_studio_emulator_guide.md)

---

## Executive Summary & Vision

The **Custom Multi-OS Android System** is an advanced, specialized Android 14 operating system engineered to provide:
1. **Unrestricted Developer & Security Testing**: Native root access (`su`), relaxed SELinux rules, framework signature spoofing, and low-level debugging capabilities.
2. **Complete Google & Daily Driver Ecosystem**: Full Google Apps / MicroG integration, Play Store, SIM Telephony/Calling, SMS, and media services.
3. **Cross-Platform Multi-OS Execution**:
   - **Windows Applications (.exe)**: Executing Windows binaries via a Wine + Box64 translation layer (Winlator container).
   - **Linux Desktop & CLI Environment**: Running a full Linux desktop via Termux-X11 + Debian/Ubuntu chroot.
   - **iOS / Apple Compatibility Bridge**: Running legacy 32-bit iOS apps via TouchHLE and modern iOS services via Web PWA containers.

---

## Full Project Progress Summary (Chat 1 to Present)

### 1. Repository Setup & Version Control
- **GitHub Repository**: `https://github.com/GarvZenith/Android_OS.git` (Branch: `main`).
- **Developer & Author**: Garv Verma (`GarvZenith` / `garvv87@gmail.com`).
- **Directory Structure**:
  - `docs/`: Consolidated technical documentation suite.
  - `patches/`: Signature spoofing patch, embedded root Makefile, and kernel defconfig.
  - `scripts/`: Environment setup (`setup_env.sh`), source sync (`sync_source.sh`), patch applier (`apply_patches.sh`), and ROM builder (`build_rom.sh`).
  - `modules/`: Ecosystem container definitions (`microg/`, `winlator/`, `termux_x11/`, `touchhle/`).

### 2. Drive & Storage Optimization (`E:\android\aosp`)
- Configured NTFS Case-Sensitivity on `E:\android` (`fsutil.exe file setCaseSensitiveInfo "E:\android" enable`).
- Configured Windows ACL permissions (`icacls E:\android /grant "Everyone:(OI)(CI)F"`).
- Configured `/etc/wsl.conf` with `metadata,case=dir,uid=1000,gid=1000,umask=022`.
- Optimized git shallow clone (`--depth=1`) and reclaimed **142 GB of space** by cleaning dangling `.repo` git cache files once source code files were checked out.
- Cleaned non-essential heavy test suites (`cts/`, `developers/`, `pdk/`, `platform_testing/`, `prebuilts/ndk/`, `prebuilts/gcc/`).

### 3. Patches & Container Modules Application
- Successfully executed `bash scripts/apply_patches.sh /mnt/e/android/aosp`:
  - ✅ Framework Signature Spoofing Patch applied to `frameworks/base`.
  - ✅ Embedded Root `su` Makefile rule registered.
  - ✅ Multi-OS Modules (`microg`, `winlator`, `termux_x11`, `touchhle`) linked to `/vendor/extra/packages/`.
  - ✅ Kernel Flags (KVM, eBPF, Box64 memory layout, Permissive SELinux) validated.

### 4. Build Environment & Target Configuration
- **Target Architecture**: `x86_64` (for Android Studio Emulator / QEMU).
- **Target Product**: `aosp_x86_64-userdebug`.
- **Environment**: `source build/envsetup.sh` + `lunch aosp_x86_64-userdebug`.
- **Selective Dependency Syncs**: Synced `clang/host/linux-x86`, `vndk/v29-v33`, `hardware/interfaces`, `system/libhidl`, `system/apex`, `system/bpf`, `system/extras`, `tools/tradefederation`, `prebuilts/rust`, `cts`, `sdk`, `prebuilts/sdk`.
- **Compilation Execution**: `m systemimage vendorimage ramdisk -j2` running in `/mnt/e/android/aosp`.

---

## Consolidated Documentation Suite

All project documentation is consolidated in the `docs/` folder:

- 📖 **[IMPLEMENTATION_PLAN.MD](docs/implementation_plan.md)**: Master consolidated implementation plan (v1 through v4).
- 📖 **[PROJECT_ROADMAP.MD](docs/PROJECT_ROADMAP.md)**: 5-phase milestone roadmap & timeline chart.
- 📖 **[DEVELOPMENT_GUIDE.MD](docs/DEVELOPMENT_GUIDE.md)**: Developer setup, toolchain requirements, and build commands.
- 📖 **[ANDROID_STUDIO_EMULATOR_GUIDE.MD](docs/android_studio_emulator_guide.md)**: Guide for creating, configuring, and testing system images in Android Studio AVD.
- 📖 **[TROUBLESHOOTING_AND_BEST_PRACTICES.MD](docs/troubleshooting_and_best_practices.md)**: Comprehensive post-mortem, pitfalls, NTFS fixes, and Soong error resolutions.
- 📖 **[MODULAR_DEVELOPMENT_WORKFLOW.MD](docs/MODULAR_DEVELOPMENT_WORKFLOW.md)**: Storage-efficient modular development workflow.
- 📖 **[FLASHING_AND_SETUP.MD](docs/FLASHING_AND_SETUP.md)**: Physical phone bootloader unlock & TWRP flashing guide.
- 📖 **[ARCHITECTURE.MD](docs/architecture.md)**: Subsystem specification (Root, MicroG, Winlator, Termux-X11, TouchHLE, SIM RIL).
- 📖 **[HARDWARE_REQUIREMENTS.MD](docs/hardware_requirements.md)**: Hardware recommendations and storage optimization guidelines.
- 📖 **[DEVICE_SETUP_CHECKLIST.MD](docs/device_setup_checklist.md)**: Physical phone preparation checklist.
- 📖 **[MULTI_OS_COEXISTENCE_GUIDE.MD](docs/multi_os_coexistence_guide.md)**: Multi-window split-screen usage guide.

---

## Quick Start Build Commands

```bash
# 1. Navigate to AOSP Source Tree in WSL2
cd /mnt/e/android/aosp

# 2. Load Build Environment Variables
source build/envsetup.sh

# 3. Select Target Product
lunch aosp_x86_64-userdebug

# 4. Compile System Images (-j2 for RAM safety)
m systemimage vendorimage ramdisk -j2
```
