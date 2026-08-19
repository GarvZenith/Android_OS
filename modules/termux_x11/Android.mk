# ==============================================================================
# Termux-X11 & Linux Subsystem Module Configuration
# Custom Multi-OS Android System
# ==============================================================================

LOCAL_PATH := $(call my-dir)

# 1. Termux Core Terminal App
include $(CLEAR_VARS)
LOCAL_MODULE := Termux
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := Termux.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

# 2. Termux-X11 Display Server
include $(CLEAR_VARS)
LOCAL_MODULE := TermuxX11
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := TermuxX11.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)
