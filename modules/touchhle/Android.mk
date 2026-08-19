# ==============================================================================
# TouchHLE iOS Runtime Engine Module Configuration
# Custom Multi-OS Android System
# ==============================================================================

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := TouchHLE
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := TouchHLE.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)
