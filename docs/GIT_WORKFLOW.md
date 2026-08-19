# Git Workflow, Commit Policies & GitHub Release Management

This document defines the git branching model, commit message conventions, GitHub remote synchronization, and release packaging rules.

---

## 1. Branching Model

- `main` / `master`: Production-ready releases and stable ROM build configurations.
- `develop`: Ongoing development, experimental feature additions, and patch integration.
- `feature/<feature-name>`: Specific subsystem work (e.g. `feature/winlator-integration`, `feature/signature-spoofing`).

---

## 2. Commit Message Conventions

Use conventional commits format for all changes:

```
<type>(<scope>): <short summary>

[optional body describing technical details]
```

### Commit Types:
- `feat`: A new feature or subsystem integration (e.g., `feat(winlator): add Wine 9.0 translation container`).
- `fix`: A bug fix or patch (e.g., `fix(selinux): relax policy for su root access`).
- `docs`: Documentation updates (e.g., `docs(readme): update project roadmap`).
- `build`: Build system or kernel configuration changes (e.g., `build(kernel): enable KVM and eBPF flags`).
- `refactor`: Code restructuring without changing functionality.

---

## 3. GitHub Remote Linking & Synchronizing

When linking local workspace to GitHub remote:

```bash
# Add GitHub remote origin
git remote add origin https://github.com/<username>/<repo-name>.git

# Rename branch to main
git branch -M main

# Push initial commits
git push -u origin main
```

### Routine Push Workflow (After Every Feature Change)
```bash
git add .
git commit -m "feat(module): short description of change"
git push origin main
```

---

## 4. GitHub Release & Asset Packaging Policy

For every compiled custom ROM build release:
1. Create a Git Tag:
   ```bash
   git tag -a v1.0.0 -m "Custom Multi-OS Android ROM Release v1.0.0"
   git push origin v1.0.0
   ```
2. Upload Release Assets to GitHub:
   - Flashable ROM `.zip` (e.g. `MultiOS-Android-v1.0.0-sweet.zip`)
   - Recovery image `boot.img` / `recovery.img`
   - SHA256 checksum file (`sha256sum.txt`)
   - Changelog release notes
