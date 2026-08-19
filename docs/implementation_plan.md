# Custom Android OS Development Plan (Physical Phone Target)

This plan outlines the architecture, build environment, and feature set for building a **Custom Android OS ROM** to flash onto a **Physical Smartphone**.

---

## System Goals & Capabilities

1. **Unrestricted App & Security Testing**:
   - Built-in Root privilege (`su` binary / APatch / Magisk).
   - Disabled/Permissive SELinux policies & signature spoofing.
   - SSL Pinning bypass and traffic interception (Frida / eBPF hooks).
   - Direct read/write access to `/system`, `/vendor`, and `/data/data`.

2. **Daily Driver Telephony & Google Ecosystem**:
   - Native SIM RIL integration for voice calls, VoLTE, and SMS.
   - Integrated Google Play Services (MicroG or GApps) & Google Play Store.

3. **Multi-OS Compatibility Engine**:
   - **Linux Subsystem**: Embedded Debian/Ubuntu rootfs with Termux-X11 desktop & VS Code.
   - **Windows Container**: Wine + Box64 / Winlator integrated into OS launcher for running `.exe` apps.
   - **iOS Bridge**: TouchHLE 32-bit iOS binary engine + Web PWA / iCloud containers.

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

## Phase Breakdown

### Phase 1: Device Identification & Source Tree Setup
- Identify target phone brand, model name, and device codename (e.g. `beryllium`, `sweet`, `chime`).
- Download/Clone AOSP / LineageOS base source tree, device tree, kernel source, and proprietary vendor blobs.

### Phase 2: System Framework & Security Modifications
- Modify framework code to allow signature spoofing and unsigned APK installs.
- Embed `su` root daemon and root management app into `/system/priv-app`.
- Configure kernel for KVM / Docker / PRoot / Box64 virtual memory requirements.

### Phase 3: Telephony & Google Ecosystem Integration
- Configure vendor RIL (Radio Interface Layer) blobs for cellular SIM calls & mobile data.
- Integrate GApps / MicroG package into OS system partition.

### Phase 4: Multi-OS Engine Pre-integration
- Pre-pack Winlator (Wine + Box64) runtime files in `/data/media/0/Winlator`.
- Pre-install Linux X11 desktop environment and terminal binaries.
- Pre-install TouchHLE iOS runtime engine.

### Phase 5: Build Compilation & Flashing Guide
- Run `make target_files_package` / `brunch` to generate flashable ZIP.
- Provide custom recovery (TWRP/OrangeFox) or Fastboot flashing commands.
