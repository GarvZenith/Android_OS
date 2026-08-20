# Fixing Git Lock Ref Errors in Repo Workspace

This document explains how to resolve:
`error: cannot lock ref 'refs/remotes/m/android-14.0.0_r1': unable to create directory for ...`

---

## 🔍 Root Cause Analysis

During interrupted `repo sync` runs, Git creates loose ref files under `.repo/repo/.git/refs/remotes/m`. If a file named `m` is created instead of a directory `m/`, Git fails with `unable to create directory` when trying to write manifest refs.

---

## 🛠️ Instant Fix

Run the following commands in **Ubuntu Terminal**:

```bash
cd /mnt/e/android/aosp

# 1. Clean stale manifest git refs
rm -rf .repo/repo/.git/refs/remotes/m* .repo/manifests.git/refs/remotes/m*

# 2. Resume sync
repo sync -c -j4 --force-sync
```
