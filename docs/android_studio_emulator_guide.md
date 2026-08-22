# E: Drive Setup & WSL2 NTFS Permission Guide for Custom Android OS

This document explains how to set up **`E:\android`** (Linux path: `/mnt/e/android`) on Windows for AOSP compilation and Android Studio Emulator testing, including NTFS case-sensitivity (`fsutil`) and WSL2 metadata permission configuration.

---

## 🛠️ STEP-BY-STEP E: DRIVE & NTFS PERMISSION SETUP

### Step 1: Create `E:\android` Directory (Windows PowerShell Admin)
Open **PowerShell as Administrator** and run:
```powershell
mkdir E:\android
```

---

### Step 2: Enable NTFS Case-Sensitivity on `E:\android`
Android OS / AOSP source compilation **requires case-sensitive filenames** (e.g. `Build` vs `build`).
In PowerShell (Admin), run:
```powershell
fsutil.exe file setCaseSensitiveInfo "E:\android" enable
```
To verify:
```powershell
fsutil.exe file queryCaseSensitiveInfo "E:\android"
```
*(Expected Output: Case sensitive attribute on directory E:\android is enabled.)*

---

### Step 3: Configure WSL2 Linux Mount Permissions (`/etc/wsl.conf`)
Open your **Ubuntu Linux Terminal** (`wsl` or `Ubuntu`) and configure `/etc/wsl.conf` so WSL mounts `E:` drive with Linux file metadata and permissions:

Run in Ubuntu terminal:
```bash
sudo bash -c 'cat <<EOF > /etc/wsl.conf
[automount]
enabled = true
options = "metadata,case=dir,uid=1000,gid=1000,umask=022"
mountFsTab = true
EOF'
```

---

### Step 4: Restart WSL2 to Apply New Mount Options
In **PowerShell (Admin)**, restart WSL2:
```powershell
wsl --shutdown
```
Then re-open **Ubuntu Linux Terminal** (`wsl`).

---

### Step 5: Verify Permissions in `/mnt/e/android`
In **Ubuntu Linux Terminal**:
```bash
cd /mnt/e/android
touch test_perm && chmod +x test_perm && ls -la test_perm && rm test_perm
```
If `test_perm` shows executable permissions (`-rwxr-xr-x`), NTFS permissions are fully configured!

---

## ⚙️ STEP 1 COMPILED COMMANDS ON E: DRIVE (`/mnt/e/android`)

Now run all AOSP source compilation steps inside `/mnt/e/android`:

### Phase 1: Directory Setup
- **Linux Path**: `/mnt/e/android/aosp`
- **Commands**:
  ```bash
  cd /mnt/e/android
  mkdir -p aosp
  cd aosp
  ```

### Phase 2: Install Build Dependencies & Sync
- **Command**:
  ```bash
  sudo apt update && sudo apt install -y \
      git-core gnupg flex bison build-essential zip curl zlib1g-dev \
      gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev \
      x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
      libxml2-utils xsltproc unzip fontconfig openjdk-17-jdk python3 \
      rsync schedtool ccache libssl-dev repo
  ```

- **Sync Commands**:
  ```bash
  repo init -u https://android.googlesource.com/platform/manifest -b android-14.0.0_r1
  repo sync -c -j$(nproc)
  ```

### Phase 3: Build Custom System Images
- **Commands**:
  ```bash
  source build/envsetup.sh
  lunch sdk_gphone64_x86_64-userdebug
  mka -j$(nproc)
  ```

### Phase 4: Output Files Location on E: Drive
The output files will be generated at:
- Linux Path: `/mnt/e/android/aosp/out/target/product/emulator_x86_64/`
- Windows Path: `E:\android\aosp\out\target/product\emulator_x86_64\`

Files generated:
1. `system.img`
2. `vendor.img`
3. `ramdisk.img`
4. `kernel-ranchu`

---

## 🟢 STEP 2 SETUP ON E: DRIVE (Windows SDK Path)

If Android Studio is configured to store SDK / system images on `E:\android\Sdk`:

In **Windows Command Prompt (cmd)**:
```cmd
mkdir "E:\android\Sdk\system-images\android-34\custom_multi_os\x86_64"
```
Copy `system.img`, `vendor.img`, `ramdisk.img`, `kernel-ranchu` into `E:\android\Sdk\system-images\android-34\custom_multi_os\x86_64\`.

Create `source.properties` inside that directory:
```ini
Pkg.Revision=1
Pkg.Desc=Custom Multi-OS Android System Image
SystemImage.Abi=x86_64
SystemImage.TagId=default
AndroidVersion.ApiLevel=34
```
