# ==============================================================================
# MicroG Services & GSF Proxy Module Configuration
# Multi-OS Custom Android System
# ==============================================================================

LOCAL_PATH := $(call my-dir)

# 1. MicroG GmsCore Services
include $(CLEAR_VARS)
LOCAL_MODULE := GmsCore
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := GmsCore.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_PRIVILEGED_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

# 2. MicroG GsfProxy
include $(CLEAR_VARS)
LOCAL_MODULE := GsfProxy
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := GsfProxy.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_PRIVILEGED_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

# 3. MicroG FakeStore (Play Store Proxy)
include $(CLEAR_VARS)
LOCAL_MODULE := FakeStore
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := FakeStore.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_PRIVILEGED_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)
