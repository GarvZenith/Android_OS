# Step 1 Complete Walkthrough: Setting Up Linux Terminal on Windows & AOSP Compilation

This guide provides a detailed walkthrough of **STEP 1**: how to enable and open the **Linux Terminal (WSL2 / Ubuntu)** directly inside Windows, exact paths, and commands to compile the Custom Android OS system images for Android Studio Emulator.

---

## PART A: Windows Par Linux Terminal Kaise Open Karein (WSL2 Setup)

Windows 10/11 ke andar **WSL2 (Windows Subsystem for Linux)** ki madad se aap native Ubuntu Linux Terminal chala sakte hain:

### Method 1: Enabling & Opening WSL2 Ubuntu Terminal
1. Windows Start Menu kholein -> Type karein `PowerShell`.
2. `PowerShell` par Right-Click karein -> Select **Run as Administrator**.
3. PowerShell mein ye command chalayein:
   ```cmd
   wsl --install
   ```
4. Jab installation complete ho jaye, apne PC ko restart karein.
5. Restart hone ke baad Windows Start Menu kholein -> Type karein **Ubuntu** (ya PowerShell mein `wsl` type karke Enter dabayein).
6. Aapke samne **Linux Terminal (`garv@DESKTOP:~$`)** open ho jayega!

---

## PART B: Step 1 Compilation Commands With Exact Paths

Aapke Linux Terminal mein execution ka complete step-by-step path:

### 📍 Phase 1: Home Directory & Project Folder Setup
- **Linux Current Path**: `/home/garv/` (`~`)
- **Commands**:
  ```bash
  # Home directory mein jayein
  cd ~

  # AOSP Source code ke liye folder banayein
  mkdir -p ~/aosp

  # aosp folder ke andar jayein
  cd ~/aosp
  ```
- **New Working Path**: `/home/garv/aosp/`

---

### 📍 Phase 2: Installing Linux Build Toolchain
- **Path**: `/home/garv/aosp/`
- **Command**:
  ```bash
  sudo apt update && sudo apt install -y \
      git-core gnupg flex bison build-essential zip curl zlib1g-dev \
      gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev \
      x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
      libxml2-utils xsltproc unzip fontconfig openjdk-17-jdk python3 \
      rsync schedtool ccache libssl-dev repo
  ```

---

### 📍 Phase 3: Syncing AOSP Base Source Code
- **Path**: `/home/garv/aosp/`
- **Commands**:
  ```bash
  # Manifest initialize karein
  repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r1

  # Source code sync karein
  repo sync -c -j$(nproc)
  ```

---

### 📍 Phase 4: Environment Setup & Target Selection
- **Path**: `/home/garv/aosp/`
- **Commands**:
  ```bash
  # Build scripts setup karein
  source build/envsetup.sh

  # Emulator target select karein
  lunch sdk_gphone64_x86_64-userdebug
  ```

---

### 📍 Phase 5: Compiling Custom System Images
- **Path**: `/home/garv/aosp/`
- **Command**:
  ```bash
  mka -j$(nproc)
  ```
- **Compilation Progress**: Terminal par `[100% 125432/125432] Install: out/target/product/emulator_x86_64/system.img` dikhega.

---

### 📍 Phase 6: Generated Output Files & Paths
Build successful hone par aapke exact Linux path:
`/home/garv/aosp/out/target/product/emulator_x86_64/`

Is folder mein 4 custom image files generate hongi:
1. `/home/garv/aosp/out/target/product/emulator_x86_64/system.img`
2. `/home/garv/aosp/out/target/product/emulator_x86_64/vendor.img`
3. `/home/garv/aosp/out/target/product/emulator_x86_64/ramdisk.img`
4. `/home/garv/aosp/out/target/product/emulator_x86_64/kernel-ranchu`

In 4 files ko Step 2 ke mutabiq Windows SDK path mein copy karke Android Studio Emulator mein run kiya jayega!
