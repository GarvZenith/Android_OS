# Fixing Manifest Git Ref Directory Conflicts in Repo

This document explains how to resolve:
`error: cannot lock ref 'refs/remotes/m/android-14.0.0_r1': unable to create directory for /mnt/e/android/aosp/.repo/manifests.git/refs/remotes/m/android-14.0.0_r1`

---

## 🔍 Root Cause Analysis

A loose Git reference file named `m` exists in `.repo/manifests.git/refs/remotes/m`. Because a file named `m` exists, Git cannot create a directory named `m/` to write the target ref `m/android-14.0.0_r1`.

---

## 🛠️ Instant Resolution

Run the following command in **Ubuntu Terminal**:

```bash
cd /mnt/e/android/aosp
rm -rf .repo/manifests.git/refs/remotes .repo/repo/.git/refs/remotes
repo sync -c -j4 --force-sync
```

This removes the conflicting file `m` and allows Git to create the `m/` directory cleanly.
