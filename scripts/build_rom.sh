#!/usr/bin/env bash
# ==============================================================================
# Custom Multi-OS Android System ROM Compilation Script
# ==============================================================================

set -eo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

DEVICE_CODENAME="${1:-generic_arm64}"
BUILD_VARIANT="${2:-userdebug}"
AOSP_ROOT="${3:-$HOME/aosp_multios}"

echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}  Custom Multi-OS Android ROM Compilation Runner                ${NC}"
echo -e "${CYAN}================================================================${NC}"
echo -e "Target Device Codename: ${YELLOW}${DEVICE_CODENAME}${NC}"
echo -e "Build Variant: ${YELLOW}${BUILD_VARIANT}${NC}"
echo -e "AOSP Source Directory: ${YELLOW}${AOSP_ROOT}${NC}"

if [ ! -d "$AOSP_ROOT" ]; then
    echo -e "${RED}[ERROR] AOSP source tree directory ${AOSP_ROOT} does not exist.${NC}"
    echo -e "Run 'bash scripts/sync_source.sh' first to set up the build environment."
    exit 1
fi

cd "$AOSP_ROOT"

# 1. Initialize Build Environment
echo -e "\n${GREEN}[1/4] Initializing AOSP Build Environment...${NC}"
if [ -f "build/envsetup.sh" ]; then
    source build/envsetup.sh
else
    echo -e "${RED}[ERROR] build/envsetup.sh not found in ${AOSP_ROOT}.${NC}"
    exit 1
fi

# 2. Select Lunch Target Combo
echo -e "\n${GREEN}[2/4] Selecting Lunch Target: lineage_${DEVICE_CODENAME}-${BUILD_VARIANT}...${NC}"
lunch "lineage_${DEVICE_CODENAME}-${BUILD_VARIANT}" || lunch "aosp_${DEVICE_CODENAME}-${BUILD_VARIANT}"

# 3. Configure Multi-OS Custom Build Flags
echo -e "\n${GREEN}[3/4] Exporting Multi-OS Custom Build Environment Variables...${NC}"
export WITH_SU=true
export SELINUX_IGNORE_NEVERALLOWS=true
export INCLUDE_WINLATOR_CONTAINER=true
export INCLUDE_TERMUX_X11_SUBSYSTEM=true
export INCLUDE_MICROG_GAPPS=true
export INCLUDE_TOUCHHLE_IOS_ENGINE=true
export USE_CCACHE=1

# 4. Start Compilation
echo -e "\n${GREEN}[4/4] Launching Parallel ROM Build (mka bacon / target_files)...${NC}"
CPU_CORES=$(nproc 2>/dev/null || echo 4)
mka bacon -j"$CPU_CORES" || make target_files_package -j"$CPU_CORES"

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}  ROM Compilation Successfully Completed!                      ${NC}"
echo -e "${GREEN}  Output ZIP location: out/target/product/${DEVICE_CODENAME}/    ${NC}"
echo -e "${GREEN}================================================================${NC}"
