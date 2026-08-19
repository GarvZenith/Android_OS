# MicroG Ecosystem Module

This module pre-bakes open-source Google Play Services replacements into `/system/priv-app`:
- **GmsCore**: Core background service for location, push notifications, and API compatibility.
- **GsfProxy**: Google Services Framework proxy.
- **FakeStore**: Play Store signature spoofing helper.

Place APK binaries (`GmsCore.apk`, `GsfProxy.apk`, `FakeStore.apk`) into this folder before compiling.
