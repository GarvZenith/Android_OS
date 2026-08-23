# Multi-OS Android System (Custom ROM Project)

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Platform: Android](https://img.shields.io/badge/Platform-Android_AOSP-green.svg)](https://source.android.com)
[![Architecture: Multi--OS](https://img.shields.io/badge/Ecosystems-Android_%7C_Linux_%7C_Windows_%7C_iOS-orange.svg)](#multi-os-coexistence-architecture)

A specialized **Custom Android OS ROM** engineered to transform any physical smartphone or target device into an **unrestricted developer testing machine** and a **multi-OS daily driver**.

---

## Key Highlights

- **Unrestricted Security & App Testing**: Native Root access (`su`), Permissive SELinux toggle, Signature Spoofing, and built-in Frida / SSL Pinning bypass.
- **Daily Driver Telephony & Google Ecosystem**: Full SIM RIL support for phone calls, SMS, VoLTE, and Google Play Store / MicroG integration.
- **Embedded Linux Subsystem**: Full Debian/Ubuntu environment with Termux-X11 desktop, VS Code, and terminal tools.
- **Embedded Windows Container**: Wine 9.x + Box64 / Winlator runtime for executing Windows `.exe` desktop software.
- **iOS / Apple Compatibility Bridge**: TouchHLE 32-bit iOS binary engine + Web PWA / iCloud container integration.
- **Simultaneous Multi-Window Execution**: Run Android, Windows, Linux, and iOS apps side-by-side on the same screen at the same time.

---

## Multi-OS Coexistence Architecture

```
+-------------------------------------------------------------------------------+
|                       Multi-Window Desktop Workspace                          |
|                                                                               |
|  +-------------------+  +-------------------+  +---------------------------+  |
|  |    Android App    |  |  Windows App (.exe)| |     Linux X11 Desktop     |  |
|  |  (Play Store /    |  | (Winlator / Wine  | |   (VS Code / Terminal /   |  |
|  |   WhatsApp / Maps)|  |   / Box64 Layer)  | |       Debian Apps)      |  |
|  +-------------------+  +-------------------+  +---------------------------+  |
|                                                                               |
|  +-------------------------------------------------------------------------+  |
|  |                         iOS Service & PWA Container                     |  |
|  |                (TouchHLE / iCloud / Apple Web / AirMessage)             |  |
|  +-------------------------------------------------------------------------+  |
+-------------------------------------------------------------------------------+
|                       Custom AOSP Kernel & System Services                    |
+-------------------------------------------------------------------------------+
```

---

## Repository Documentation Index

All detailed specifications, plans, and guides are structured inside the [`docs/`](docs/) directory:

- 📖 **[PROJECT_ROADMAP.md](docs/PROJECT_ROADMAP.md)**: Step-by-step master development plan from source code setup to ROM compilation.
- 📖 **[DEVELOPMENT_GUIDE.md](docs/DEVELOPMENT_GUIDE.md)**: Source code building, kernel patching, and module injection guide.
- 📖 **[ANDROID_STUDIO_EMULATOR_GUIDE.md](docs/android_studio_emulator_guide.md)**: Running & testing Custom Android OS in Android Studio Emulator.
- 📖 **[GIT_WORKFLOW.md](docs/GIT_WORKFLOW.md)**: Git policies, commit conventions, versioning, and GitHub release workflow.
- 📖 **[FLASHING_AND_SETUP.md](docs/FLASHING_AND_SETUP.md)**: Bootloader unlocking, TWRP/OrangeFox recovery installation, and ROM flashing guide.
- 📖 **[ARCHITECTURE.MD](docs/architecture.md)**: Technical specification of all core subsystems.
- 📖 **[HARDWARE_REQUIREMENTS.MD](docs/hardware_requirements.md)**: Processor (Qualcomm Snapdragon), RAM, and storage recommendations.
- 📖 **[IMPLEMENTATION_PLAN_V4.MD](docs/implementation_plan_v4_android_studio_emulator.md)**: Android Studio Emulator target plan.
- 📖 **[DEVICE_SETUP_CHECKLIST.MD](docs/device_setup_checklist.md)**: Physical phone preparation checklist.
- 📖 **[MULTI_OS_COEXISTENCE_GUIDE.MD](docs/multi_os_coexistence_guide.md)**: Multi-window split-screen usage guide.
- 📖 **[MODULAR_DEVELOPMENT_WORKFLOW.MD](docs/MODULAR_DEVELOPMENT_WORKFLOW.md)**: Storage-efficient modular development workflow.
- 📖 **[TROUBLESHOOTING_WSL_NTFS.MD](docs/troubleshooting_wsl_ntfs.md)**: Troubleshooting WSL2 E: drive NTFS permissions & `icacls` resolution guide.

---

## Quick Start (For Developers)

### 1. Requirements
- Host Machine: Ubuntu 22.04 LTS (or Windows 11 WSL2) with 32 GB RAM & 300 GB SSD space.
- Build Toolchain: `git`, `repo`, `openjdk-17-jdk`, `python3`, `bison`, `flex`, `zip`.

### 2. Building the ROM
```bash
# Clone the repository
git clone <your-github-repo-url>
cd Android_OS

# Initialize AOSP build environment
source build/envsetup.sh

# Target device configuration (e.g. device_codename)
lunch custom_android_<device_codename>-userdebug

# Compile flashable ZIP package
make bacon -j$(nproc)
```

---

## License

Distributed under the **Apache License 2.0**. See [`LICENSE`](LICENSE) for details.
