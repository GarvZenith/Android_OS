# Step 1 Complete Walkthrough: WSL2 Ubuntu Setup on E:\ Drive & AOSP Compilation

This guide provides a detailed walkthrough of **STEP 1** customized specifically for storing and building the Custom Android OS on **Drive E:\** (`E:\android` / `/mnt/e/android`) to save space on Drive C:\.

---

## 📍 Windows Drive E:\ Mapping & Disk Space Requirements

> [!CAUTION]
> **Disk Space Requirement**
> A full AOSP source code checkout requires **150 GB to 250 GB of free disk space** on Drive E:\.
> If disk space is low, use the **Lightweight Shallow Sync** command (`--depth=1 --no-clone-bundle`).

---

## ⚙️ PART 2: Modified Commands With Exact E:\ Drive Paths (`/mnt/e/android`)

Execute these commands inside your **Ubuntu Linux Terminal**:

### 📍 Phase 1: Creating Workspace Folder, Git Identity & Drive Permissions
- **Target Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  # 1. Configure Git Identity (User: GarvZenith, Email: garvv87@gmail.com)
  git config --global user.email "garvv87@gmail.com"
  git config --global user.name "GarvZenith"
  git config --global core.filemode false

  # 2. Enable Linux metadata permissions on E:\ drive
  sudo umount /mnt/e 2>/dev/null
  sudo mount -t drvfs E: /mnt/e -o metadata

  # 3. E:\ drive par android aur aosp folder banayein
  mkdir -p /mnt/e/android/aosp

  # 4. aosp folder ke andar jayein
  cd /mnt/e/android/aosp
  ```
- **Current Working Path**: `/mnt/e/android/aosp`

---

### 📍 Phase 2: Installing Standalone Official Repo Tool & Build Toolchain
- **Current Working Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  # 1. Install Google Standalone Repo Tool
  sudo curl -fsSL https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo
  sudo chmod a+rx /usr/local/bin/repo

  # 2. Install AOSP build dependencies
  sudo apt update && sudo apt install -y \
      git gnupg flex bison build-essential zip curl zlib1g-dev \
      gcc-multilib g++-multilib libc6-dev-i386 libncurses-dev \
      x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
      libxml2-utils xsltproc unzip fontconfig openjdk-17-jdk python3 \
      rsync schedtool ccache libssl-dev
  ```

---

### 📍 Phase 3: Lightweight Shallow Syncing AOSP Base Source Code on E:\ Drive
- **Current Working Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  # Clean old build artifacts & initialize clean manifest
  cd /mnt/e/android/aosp && rm -rf .repo
  /usr/local/bin/repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r1 --no-repo-verify --depth=1

  # Lightweight shallow sync (Saves ~60% disk space)
  /usr/local/bin/repo sync -c --no-clone-bundle --no-tags -j4
  ```

---

### 📍 Phase 4: Build Environment & Target Select Karna
- **Current Working Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  # Build scripts setup karein
  source build/envsetup.sh

  # Emulator target select karein
  lunch sdk_gphone64_x86_64-userdebug
  ```

---

### 📍 Phase 5: Compiling Custom System Images
- **Current Working Path**: `/mnt/e/android/aosp`
- **Command**:
  ```bash
  mka -j$(nproc)
  ```
- **Progress Output**: Terminal par `[100% 125432/125432] Install: out/target/product/emulator_x86_64/system.img` show karega.

---

### 📍 Phase 6: Output Files ka Exact Path (E:\ Drive)

Compilation successful hone par aapke 4 custom system image files is exact path par generate hongi:

- **Ubuntu Linux Path**: `/mnt/e/android/aosp/out/target/product/emulator_x86_64/`
- **Windows File Explorer Path**: `E:\android\aosp\out\target\product\emulator_x86_64\`

Generated Files:
1. `E:\android\aosp\out\target\product\emulator_x86_64\system.img`
2. `E:\android\aosp\out\target\product\emulator_x86_64\vendor.img`
3. `E:\android\aosp\out\target\product\emulator_x86_64\ramdisk.img`
4. `E:\android\aosp\out\target\product\emulator_x86_64\kernel-ranchu`
