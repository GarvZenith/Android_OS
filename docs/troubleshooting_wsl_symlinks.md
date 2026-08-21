# Fixing ManifestInvalidRevisionError (refs/tags/android-14.0.0_r1 not found)

This document explains how to resolve:
`ManifestInvalidRevisionError: revision refs/tags/android-14.0.0_r1 in ... not found`

---

## 🔍 Root Cause Analysis
Using `repo sync -l` (local-only mode) skips fetching tag definitions from remote into `.repo/manifests.git`. When checking out projects that reference specific tag revisions, Git throws `ManifestInvalidRevisionError`.

---

## 🛠️ Instant Resolution

Run the following command in **Ubuntu Terminal**:

```bash
cd /mnt/e/android/aosp
repo sync -c -j4 --no-tags --force-sync
```

This fetches the small 2 MB tag manifest definitions and completes the remaining 91% to 100% checkout cleanly.
