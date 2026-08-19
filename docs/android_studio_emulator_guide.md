# Step 1 Complete Walkthrough: WSL2 Ubuntu Setup on E:\ Drive & AOSP Compilation

This guide provides a detailed walkthrough of **STEP 1** customized specifically for storing and building the Custom Android OS on **Drive E:\** (`E:\android` / `/mnt/e/android`) to save space on Drive C:\.

---

## 📍 Windows Drive E:\ Mapping & WSL2 Metadata Configuration

Ubuntu Linux terminal mounts your Windows **E:\** drive under `/mnt/e/`.
- Windows Path: `E:\android`
- Ubuntu Linux Path: `/mnt/e/android`

> [!IMPORTANT]
> **WSL2 NTFS Permission & Direct Manifest Setup**
> Before running `repo sync` on an external Windows drive (`/mnt/e/`), ensure Linux metadata is mounted and manifest is cloned cleanly:
> ```bash
> git config --global core.filemode false
> sudo umount /mnt/e 2>/dev/null
> sudo mount -t drvfs E: /mnt/e -o metadata
> ```

---

## ⚙️ PART 2: Modified Commands With Exact E:\ Drive Paths (`/mnt/e/android`)

Execute these commands inside your **Ubuntu Linux Terminal**:

### 📍 Phase 1: Creating Workspace Folder & Fixing Drive Permissions
- **Target Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  # 1. Enable Linux metadata permissions on E:\ drive
  git config --global core.filemode false
  sudo umount /mnt/e 2>/dev/null
  sudo mount -t drvfs E: /mnt/e -o metadata

  # 2. E:\ drive par android aur aosp folder banayein
  mkdir -p /mnt/e/android/aosp

  # 3. aosp folder ke andar jayein
  cd /mnt/e/android/aosp
  ```
- **Current Working Path**: `/mnt/e/android/aosp`

---

### 📍 Phase 2: Installing Linux Build Toolchain
- **Current Working Path**: `/mnt/e/android/aosp`
- **Command**:
  ```bash
  sudo apt update && sudo apt install -y \
      git gnupg flex bison build-essential zip curl zlib1g-dev \
      gcc-multilib g++-multilib libc6-dev-i386 libncurses-dev \
      x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
      libxml2-utils xsltproc unzip fontconfig openjdk-17-jdk python3 \
      rsync schedtool ccache libssl-dev repo
  ```

---

### 📍 Phase 3: Manifest Linking & Syncing AOSP Base Source Code on E:\ Drive
- **Current Working Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  # Manifest initialize & link
  mkdir -p .repo/manifests && git clone https://android.googlesource.com/platform/manifest -b android-14.0.0_r1 .repo/manifests && ln -sf manifests/default.xml .repo/manifest.xml

  # Full source code E:\ drive par sync/download karein
  repo sync -c -j$(nproc)
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
