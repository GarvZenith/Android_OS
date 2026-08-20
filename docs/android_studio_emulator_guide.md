# Step 1 Complete Walkthrough: WSL2 Ubuntu Setup on E:\ Drive & AOSP Compilation

This guide provides a detailed walkthrough of **STEP 1** customized specifically for storing and building the Custom Android OS on **Drive E:\** (`E:\android` / `/mnt/e/android`) to save space on Drive C:\.

---

## 📍 Windows Drive E:\ Mapping & Disk Space Management

> [!TIP]
> **Post-Compilation Cleanup Policy**
> Once the custom OS compilation is complete and output images (`system.img`, `vendor.img`, etc.) are copied to Android Studio SDK or saved as GitHub Releases, the entire raw source code directory `E:\android\aosp` (150-200 GB) **can be deleted completely** to free up disk space. Your custom OS emulator will continue to run independently.

---

## ⚙️ PART 2: Modified Commands With Exact E:\ Drive Paths (`/mnt/e/android`)

Execute these commands inside your **Ubuntu Linux Terminal**:

### 📍 Phase 1: Workspace Folder & Drive Permissions
- **Target Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  # 1. Configure Git Identity
  git config --global user.email "garvv87@gmail.com"
  git config --global user.name "GarvZenith"
  git config --global core.filemode false

  # 2. Enable Linux metadata permissions on E:\ drive
  sudo umount /mnt/e 2>/dev/null
  sudo mount -t drvfs E: /mnt/e -o metadata

  # 3. Enter workspace directory
  cd /mnt/e/android/aosp
  ```

---

### 📍 Phase 2: Installing Standalone Official Repo Tool
- **Current Working Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  # Install Google Standalone Repo Tool
  sudo curl -fsSL https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo
  sudo chmod a+rx /usr/local/bin/repo
  ```

---

### 📍 Phase 3: Finalizing Local Tree Checkout (--local-only)
- **Current Working Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  # 1. Clean corrupted build/bazel folder from previous I/O error
  cd /mnt/e/android/aosp && rm -rf build/bazel .repo/projects/build/bazel.git .repo/project-objects/platform/build/bazel.git

  # 2. Finalize local checkout (reuses downloaded 100% repos without re-downloading)
  /usr/local/bin/repo sync -c --force-sync -j4 --local-only
  ```

---

### 📍 Phase 4: Build Environment & Target Selection
- **Current Working Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  # Build scripts setup
  source build/envsetup.sh

  # Emulator target select
  lunch sdk_gphone64_x86_64-userdebug
  ```

---

### 📍 Phase 5: Compiling Custom System Images
- **Current Working Path**: `/mnt/e/android/aosp`
- **Command**:
  ```bash
  mka -j$(nproc)
  ```

---

### 📍 Phase 6: Output Files & Cleanup
After compilation completes:
1. Compiled Output Images: `E:\android\aosp\out\target\product\emulator_x86_64\`
2. Copy `system.img`, `vendor.img`, `ramdisk.img`, `kernel-ranchu` to Android Studio SDK.
3. **Optional Cleanup**: Delete `E:\android\aosp` folder to reclaim ~200 GB disk space.
