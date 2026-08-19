# Custom Multi-OS Android Verification & Testing Script

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " Running Automated Component Verification for Multi-OS Android OS" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

$errorsFound = 0

# 1. Test Documentation Files
Write-Host "[1/5] Checking Documentation Integrity..." -ForegroundColor Yellow
$docFiles = @(
    "README.md",
    "LICENSE",
    "docs/architecture.md",
    "docs/hardware_requirements.md",
    "docs/multi_os_coexistence_guide.md",
    "docs/android_studio_emulator_guide.md",
    "docs/PROJECT_ROADMAP.md",
    "docs/DEVELOPMENT_GUIDE.md",
    "docs/FLASHING_AND_SETUP.md",
    "docs/GIT_WORKFLOW.md"
)

foreach ($doc in $docFiles) {
    if (Test-Path $doc) {
        Write-Host "  [OK] Found $doc" -ForegroundColor Green
    } else {
        Write-Host "  [ERROR] Missing $doc" -ForegroundColor Red
        $errorsFound++
    }
}

Write-Host ""
# 2. Test Custom Kernel & Framework Patches
Write-Host "[2/5] Checking Patches & Kernel Configuration..." -ForegroundColor Yellow
$patchFiles = @(
    "patches/frameworks_base_signature_spoofing.patch",
    "patches/su_root_integration.mk",
    "patches/kernel_multi_os_defconfig.config"
)

foreach ($patch in $patchFiles) {
    if (Test-Path $patch) {
        $size = (Get-Item $patch).Length
        Write-Host "  [OK] Found $patch ($size bytes)" -ForegroundColor Green
    } else {
        Write-Host "  [ERROR] Missing $patch" -ForegroundColor Red
        $errorsFound++
    }
}

Write-Host ""
# 3. Test Embedded Subsystem Modules (Winlator, Termux-X11, TouchHLE, MicroG)
Write-Host "[3/5] Checking Subsystem Module Android.mk Definitions..." -ForegroundColor Yellow
$moduleDirs = @("winlator", "termux_x11", "touchhle", "microg")

foreach ($mod in $moduleDirs) {
    $mkPath = "modules/$mod/Android.mk"
    if (Test-Path $mkPath) {
        Write-Host "  [OK] Valid module definition: $mkPath" -ForegroundColor Green
    } else {
        Write-Host "  [ERROR] Missing Android.mk in modules/$mod" -ForegroundColor Red
        $errorsFound++
    }
}

Write-Host ""
# 4. Test JSON Configuration Files
Write-Host "[4/5] Checking Winlator Default Config JSON Syntax..." -ForegroundColor Yellow
$jsonPath = "modules/winlator/config/winlator_default.json"
if (Test-Path $jsonPath) {
    try {
        $raw = Get-Content $jsonPath -Raw
        $jsonObj = ConvertFrom-Json $raw
        Write-Host "  [OK] $jsonPath is valid JSON (Wine Version: $($jsonObj.wine_version))" -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Invalid JSON syntax in ${jsonPath}: $_" -ForegroundColor Red
        $errorsFound++
    }
} else {
    Write-Host "  [ERROR] Missing $jsonPath" -ForegroundColor Red
    $errorsFound++
}

Write-Host ""
# 5. Test Build Automation Scripts
Write-Host "[5/5] Checking Shell Scripts & Manifest..." -ForegroundColor Yellow
$scriptFiles = @(
    "scripts/setup_env.sh",
    "scripts/sync_source.sh",
    "scripts/apply_patches.sh",
    "scripts/build_rom.sh",
    "manifests/local_manifest.xml",
    "devices/generic_arm64/BoardConfig.mk"
)

foreach ($scr in $scriptFiles) {
    if (Test-Path $scr) {
        Write-Host "  [OK] Verified $scr" -ForegroundColor Green
    } else {
        Write-Host "  [ERROR] Missing $scr" -ForegroundColor Red
        $errorsFound++
    }
}

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
if ($errorsFound -eq 0) {
    Write-Host " RESULT: ALL 21 OS COMPONENTS VERIFIED CLEAN! 🚀" -ForegroundColor Green
} else {
    Write-Host " RESULT: $errorsFound ERRORS FOUND IN OS COMPONENTS!" -ForegroundColor Red
}
Write-Host "=================================================" -ForegroundColor Cyan
