# ==============================================================================
# Embedded Root Binary (`su`) & Superuser Build Configuration
# Custom Multi-OS Android System
# ==============================================================================

# Enable Root Binary Build Flags
WITH_SU := true
PRODUCT_PACKAGES += su

# System Build Overrides for Unrestricted Access
PRODUCT_PROPERTY_OVERRIDES += \
    ro.secure=0 \
    ro.adb.secure=0 \
    ro.debuggable=1 \
    persist.sys.usb.config=adb \
    persist.sys.strictmode.disable=true \
    ro.allow.mock.location=1

# SELinux Policy Overrides
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

# Copy Root Executable Permissions Rule
PRODUCT_COPY_FILES += \
    system/extras/su/su:system/xbin/su
