# ==============================================================================
# Generic ARM64 Board Configuration Template
# Custom Multi-OS Android System (ROM Target)
# ==============================================================================

# Target Architecture Definitions
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic

# Kernel Build Flags & Cmdline Settings
BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200n8 androidboot.hardware=qcom androidboot.selinux=permissive
BOARD_KERNEL_PAGESIZE := 4096

# Custom Multi-OS System Features Enabled
WITH_SU := true
SELINUX_IGNORE_NEVERALLOWS := true
PRODUCT_SET_DEBUGFS_RESTRICTIONS := false

# Display & Multi-Window Freeform Mode Config
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.debug.multi_window=true \
    enable_freeform_support=true \
    ro.config.desktop_mode=true
