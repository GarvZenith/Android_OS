# Custom Android OS Architecture & Subsystem Specification

## System Overview
This custom Android OS is engineered to serve as both an **unrestricted application security/development environment** and a **multi-OS daily driver**.

```
+-------------------------------------------------------------------------+
|                        Custom Android OS Launcher                       |
+-------------------+--------------------+-------------------+------------+
| Google Ecosystem  |  Linux Subsystem   | Windows Container | iOS Bridge |
| (GApps/MicroG)    | (Termux-X11/Debian)|  (Winlator/Wine)  | (TouchHLE) |
+-------------------+--------------------+-------------------+------------+
|             Telephony & Calling Subsystem (SIM RIL / VoIP)             |
+-------------------------------------------------------------------------+
|                  Developer & Security Hooking Engine                    |
|       (Root access, Permissive SELinux, Signature Spoofing, Frida)       |
+-------------------------------------------------------------------------+
|                   AOSP Base Framework & Linux Kernel                    |
+-------------------------------------------------------------------------+
```

---

## 🏛️ Project Directory Architecture (`Android_OS` vs `aosp`)

### 1. `E:\Project\Android_OS` (Master Project Control Repo)
- **Role**: **The Master Blueprint & Proprietary Repo** (Synced with GitHub `https://github.com/GarvZenith/Android_OS.git`).
- **Contains**: Your custom patches (`patches/`), custom modules (`modules/`), automation build scripts (`scripts/`), local manifests (`manifests/`), device configs (`devices/`), and full documentation (`docs/`).
- **Why it matters**: This is your primary development workspace where all new features, custom code, and documentation live permanently.

### 2. `E:\android\aosp` (AOSP Compilation Factory & Engine)
- **Role**: **The Raw Engine & OS Compiler Workspace**.
- **Contains**: Google's raw Android source code tree (Linux Kernel, Android C-library `bionic`, Java Framework, SystemUI, ART Runtime, Compilers).
- **Why it matters**: Android's compiler (`mka` / `ninja` / `soong`) requires all source code files to sit inside an AOSP tree structure to generate the final OS images (`system.img`, `vendor.img`, `kernel-ranchu`).

```
+------------------------------------+        +-----------------------------------+
|  E:\Project\Android_OS             |        |  E:\android\aosp                  |
|  (Master GitHub Repository)        | -----> |  (AOSP Build Factory & Engine)    |
|  - Custom Patches & Modules        | Inject |  - Raw Android OS Source Code     |
|  - Build Scripts & Configs         | Patches|  - Compiles system.img / vendor.img|
+------------------------------------+        +-----------------------------------+
```

---

## Subsystem Breakdown

### 1. Core OS & Security Control Layer
- **Root Management**: APatch / KernelSU / Magisk embedded directly into `/system/xbin/su`.
- **SELinux Manager**: Runtime toggle between `Enforcing` and `Permissive` modes via developer settings or ADB command (`setenforce 0`).
- **Signature Spoofing**: Patched Framework JAR (`framework.jar`) to allow signature spoofing for MicroG and testing unsigned APKs.
- **SSL Pinning & Traffic Inspection**: Integrated Frida server daemon and eBPF network packet analyzer to capture HTTP/HTTPS traffic from any installed app.

### 2. Google Ecosystem Subsystem
- **Core Services**: MicroG GmsCore + GsfProxy + Store or MindTheGapps package.
- **Play Store**: Official Google Play Store or Aurora Store for anonymous APK downloads and update management.
- **Device Certification**: SafetyNet / Play Integrity fix module to ensure banking apps and Google Pay operate smoothly.

### 3. Linux Subsystem Layer
- **Container Technology**: Termux engine with PRoot/Chroot container running Debian/Ubuntu rootfs.
- **Display Server**: Termux-X11 X Server rendering directly to Android `SurfaceFlinger`.
- **Desktop Environment**: XFCE4 / LXDE desktop with pre-installed developer tools (VS Code, Python3, Node.js, GCC, Git).

### 4. Windows Compatibility Subsystem
- **Translation Stack**: Wine 8.x / 9.x + Box64 (x86_64 to ARM64 binary translation) + DXVK (Direct3D to Vulkan).
- **Frontend App**: Winlator / Mobox custom integrated launcher shortcut on the Android desktop.
- **Supported Binaries**: Windows `.exe`, `.msi`, Win32 API calls, DirectX 9/10/11 apps and utilities.

### 5. iOS / Apple Compatibility Bridge
- **Legacy 32-bit iOS Apps**: TouchHLE high-level emulator integration for running iOS `.ipa` (Mach-O ARM) packages.
- **Apple Web Apps & PWAs**: Native container shortcuts for iCloud Mail, Calendar, Notes, Apple Music, and Web PWAs.
- **Remote iOS Streaming Bridge**: Appetize.io or Mac cloud preview integration for testing live 64-bit iOS builds.

### 6. Telephony & Communication Subsystem
- **Physical Devices**: Hardware RIL (Radio Interface Layer) driver connecting phone Modem to Android `rild` daemon for standard SIM calls and SMS.
- **Virtual / PC / Emulator Environment**: SIP/VoIP client integration and Android Telecom Manager bridge to place and receive phone calls over IP.
