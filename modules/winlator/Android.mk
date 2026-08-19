# ==============================================================================
# Winlator (Wine 9.x + Box64 Windows Container) Prebuilt Module
# Custom Multi-OS Android System
# ==============================================================================

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := Winlator
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := Winlator.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_PRIVILEGED_MODULE := true
include $(BUILD_PREBUILT)

# Copy default Wine container config and Mesa Turnip drivers to system data
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/winlator_default.json:system/etc/winlator/default.json
