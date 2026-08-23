# Selective & Modular Storage-Efficient Development Workflow Guide

This document defines the official **Modular & Storage-Efficient Development Workflow** for building the Custom Multi-OS Android System without hitting storage limits.

---

## 🎯 Modular Workflow Principles

1. **Core-Only Base Source Tree**:
   - Only maintain essential core directories (`build/`, `frameworks/`, `system/`, `packages/`, `hardware/`, `device/`, `art/`, `bionic/`, `external/`, `prebuilts/`).
   - Omit heavy non-essential directories (`cts/`, `developers/`, `pdk/`, `platform_testing/`, `test/`).

2. **Patch & Module Injection Strategy**:
   - Apply custom patches from `E:\Project\Android_OS\patches\` directly onto the AOSP core source tree.
   - Inject pre-baked ecosystem modules (`modules/microg`, `modules/winlator`, `modules/termux_x11`, `modules/touchhle`) into `vendor/extra/packages/`.

3. **Selective Component Build & Space Recycling**:
   - Compile target images (`sdk_gphone64_x86_64-userdebug` for Android Studio Emulator).
   - Clean intermediate obj files (`make installclean` / `mka clean`) after generating final `system.img` to preserve disk space.

---

## 🚀 Execution Pipeline & Exact Commands

```
+-----------------------------------------------------------------------------------+
| STEP 1: Apply Patches (Root, Signature Spoofing, Kernel)                          |
| WHERE: Ubuntu Terminal -> bash /mnt/e/Project/Android_OS/scripts/apply_patches.sh|
+-----------------------------------------------------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
| STEP 2: Inject Ecosystem Modules (Winlator, Termux-X11, MicroG, TouchHLE)        |
| WHERE: Ubuntu Terminal -> cp -r /mnt/e/Project/Android_OS/modules/* vendor/extra/ |
+-----------------------------------------------------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
| STEP 3: Setup Target Environment (sdk_gphone64_x86_64-userdebug)                  |
| WHERE: Ubuntu Terminal -> source build/envsetup.sh -> lunch                       |
+-----------------------------------------------------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
| STEP 4: Compile Custom System Images                                              |
| WHERE: Ubuntu Terminal -> mka -j$(nproc)                                          |
+-----------------------------------------------------------------------------------+
```
