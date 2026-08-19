# Hardware Requirements Specification for Custom Multi-OS Android

This document outlines the hardware requirements and recommendations for running and building the Custom Multi-OS Android system.

---

## 1. Environment-Specific Hardware Requirements

### Scenario A: Running on PC / Laptop (Virtual Machine / Dual Boot / Waydroid)
If you plan to run the OS on your current PC or Laptop:

| Component | Minimum Requirement | Recommended Requirement |
| :--- | :--- | :--- |
| **CPU** | Intel Core i5 / AMD Ryzen 5 (VT-x / AMD-V enabled) | Intel Core i7/i9 (10th+ Gen) or AMD Ryzen 7/9 |
| **RAM** | 16 GB | 32 GB (to comfortably run Android + Linux + Windows containers) |
| **GPU** | Intel Iris Xe / GTX 1050 (Vulkan 1.2 support) | NVIDIA RTX 2060+ / AMD Radeon RX 6000+ (Vulkan 1.3 + OpenGL 4.6) |
| **Storage** | 60 GB Free SSD | 128 GB+ NVMe SSD |
| **Virtualization** | Hardware Virtualization (VT-x/AMD-V) enabled in BIOS | Nested Virtualization support |

---

### Scenario B: Running on a Physical Smartphone (Custom ROM / Daily Driver)
If you plan to flash this custom OS onto a mobile phone:

| Component | Requirement & Recommendation | Why It Matters |
| :--- | :--- | :--- |
| **Chipset (Processor)** | **Qualcomm Snapdragon** (e.g., 870, 888, 8 Gen 1/2/3, 7+ Gen 2) | Snapdragon's Adreno GPU supports **Turnip (Mesa 3D)** custom graphics drivers, which are required for high-performance Windows (.exe) app translation via Winlator. |
| **RAM** | **8 GB Minimum** (12 GB - 16 GB Recommended) | Running Android daily apps + background Linux daemon + Windows x86 translation requires ample memory. |
| **Storage** | **128 GB Minimum** (256 GB Recommended) | Storage for custom OS system partition, Linux rootfs (Debian), and Windows app containers. |
| **Bootloader** | **Unlockable Bootloader** | Essential for flashing custom kernel, root (APatch/Magisk), and custom recovery (TWRP/OrangeFox). *Supported: Google Pixel, OnePlus, Xiaomi/Poco, Nothing Phone.* |
| **SIM / Telephony** | 4G / 5G VoLTE Modem with unlocked RIL | Ensures daily phone calls, SMS, and mobile data work without vendor lock. |

> [!WARNING]
> **MediaTek & Exynos Processors Notice**
> Devices with MediaTek (Dimensity) or Samsung Exynos chips can run Google apps, Linux containers, and root testing fine, but Windows (`.exe`) graphics performance will be slower because they lack Turnip Adreno GPU driver support.

---

## 2. Hardware Requirements for Compiling AOSP / OS Source Code (Host Machine)
If you decide to build the OS directly from source code:

- **OS**: Ubuntu Linux 22.04 LTS (or Windows 11 with WSL2 Linux subsystem)
- **CPU**: 8-core / 16-thread processor or higher
- **RAM**: 32 GB RAM (64 GB recommended for parallel build threads)
- **Storage**: **300 GB - 500 GB free High-Speed NVMe SSD space** (AOSP repository + build output artifacts)
