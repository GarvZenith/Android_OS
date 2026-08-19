# Windows Container Compatibility Module (Winlator + Wine + Box64)

This module pre-bakes the Windows execution engine directly into the custom ROM launcher:
- **Winlator.apk**: Container management application.
- **Wine 9.x**: Win32 / Win64 API implementation.
- **Box64**: Dynamic x86_64 to ARM64 binary translation engine.
- **DXVK**: Direct3D 9/10/11 translation to Vulkan GPU calls.

Place `Winlator.apk` inside `modules/winlator/` before system build.
