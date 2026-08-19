# BoardConfig for Android Studio x86_64 Emulator Build Target

TARGET_ARCH := x86_64
TARGET_ARCH_VARIANT := x86_64
TARGET_CPU_ABI := x86_64
TARGET_CPU_ABI2 := x86

# Enable KVM Hardware Virtualization & Vulkan Graphics Acceleration
TARGET_USES_HWC2 := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
BOARD_INSTALL_VULKAN := true

# System Partition & Dynamic Partitions Setup
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4294967296 # 4 GB
BOARD_FLASH_BLOCK_SIZE := 512

# Kernel & Boot Image Configuration
BOARD_KERNEL_CMDLINE := console=ttyS0 androidboot.hardware=ranchu androidboot.selinux=permissive
BOARD_INCLUDE_DTB_IN_BOOTIMG := true

# Security & Signature Spoofing Controls
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_SEPOLICY_DIRS += vendor/custom_os/sepolicy

# Include Multi-OS Subsystem Modules
PRODUCT_PACKAGES += \
    su \
    WinlatorContainer \
    TermuxX11Subsystem \
    TouchHLEEngine \
    MicroGCore \
    MultiOSControl
