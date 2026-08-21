# Fixing Corrupted Bazel Git Cache & Symlink Error

This document explains the exact reason for the error:
`error: Cannot checkout platform/build/bazel: NoManifestException: GitCommandError ...`

---

## 🔍 Exact Meaning of the Error

1. **`Cannot symlink ... BUILD to build/bazel/bazel.BUILD`**: AOSP root contains a file `BUILD` and a folder `build/`. On Windows NTFS drives, Windows treats uppercase `BUILD` and lowercase `build` as the same name.
2. **`unparseable HEAD ... not a git repository`**: During an interrupted sync, the git metadata cache for the `build/bazel` repository (`.repo/projects/build/bazel.git`) became corrupted.

---

## 🛠️ Instant 1-Line Fix: Clean Corrupted Bazel Cache & Resume Sync

Run the following command in **Ubuntu Terminal**:

```bash
cd /mnt/e/android/aosp
rm -rf build/bazel BUILD .repo/projects/build/bazel.git .repo/project-objects/platform/build/bazel.git
repo sync -c -j4 --force-sync
```

This deletes the single corrupted `build/bazel` cache (takes 2 seconds) without touching your 100GB downloaded code, allowing `repo sync` to re-download `bazel` cleanly and finish!
