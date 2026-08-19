#!/usr/bin/env bash
# ==============================================================================
# AOSP / LineageOS Source Tree Synchronization Script
# Custom Multi-OS Android System
# ==============================================================================

set -eo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default configuration settings
BRANCH="${1:-lineage-20.0}"
TARGET_DIR="${2:-$HOME/aosp_multios}"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}  Custom Multi-OS Android ROM - Source Synchronization         ${NC}"
echo -e "${CYAN}================================================================${NC}"
echo -e "Target Branch: ${YELLOW}${BRANCH}${NC}"
echo -e "Source Tree Directory: ${YELLOW}${TARGET_DIR}${NC}"
echo -e "Project Working Directory: ${YELLOW}${PROJECT_ROOT}${NC}"

# Ensure repo executable is available
if ! command -v repo &> /dev/null; then
    export PATH="$HOME/bin:$PATH"
    if ! command -v repo &> /dev/null; then
        echo -e "${RED}[ERROR] `repo` tool not found. Please run 'bash scripts/setup_env.sh' first.${NC}"
        exit 1
    fi
fi

# 1. Create Target Directory & Initialize Repository
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

if [ ! -d ".repo" ]; then
    echo -e "\n${GREEN}[1/3] Initializing LineageOS Base Tree (${BRANCH})...${NC}"
    repo init -u https://github.com/LineageOS/android.git -b "$BRANCH" --git-lfs --depth=1
else
    echo -e "\n${GREEN}[1/3] Repository already initialized in ${TARGET_DIR}.${NC}"
fi

# 2. Inject Local Manifests from Repository
echo -e "\n${GREEN}[2/3] Injecting Custom Multi-OS Local Manifests...${NC}"
mkdir -p "$TARGET_DIR/.repo/local_manifests"

if [ -f "$PROJECT_ROOT/manifests/local_manifest.xml" ]; then
    cp "$PROJECT_ROOT/manifests/local_manifest.xml" "$TARGET_DIR/.repo/local_manifests/multios_manifest.xml"
    echo -e "  - Copied ${PROJECT_ROOT}/manifests/local_manifest.xml to local_manifests/multios_manifest.xml"
else
    echo -e "${YELLOW}  - Notice: No manifests/local_manifest.xml found. Proceeding with standard base manifest.${NC}"
fi

# 3. Synchronize Repository
echo -e "\n${GREEN}[3/3] Starting Repository Sync (using 8 parallel jobs)...${NC}"
repo sync -c -j8 --force-sync --no-clone-bundle --no-tags

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}  Source Sync Completed Successfully!                          ${NC}"
echo -e "${GREEN}  Next Step: Run 'bash scripts/apply_patches.sh' to patch tree.${NC}"
echo -e "${GREEN}================================================================${NC}"
