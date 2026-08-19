#!/usr/bin/env bash
# ==============================================================================
# Setup Environment & Host Dependency Installer for Custom Multi-OS Android ROM
# Target Host System: Ubuntu 22.04 LTS / Debian 12 / WSL2 Linux
# ==============================================================================

set -eo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}  Custom Multi-OS Android System - Build Host Setup Script      ${NC}"
echo -e "${CYAN}================================================================${NC}"

# 1. System Requirements & Hardware Audit
echo -e "\n${GREEN}[1/4] Checking Host System Specifications...${NC}"

TOTAL_RAM_GB=$(free -g 2>/dev/null | awk '/^Mem:/{print $2}' || echo 0)
FREE_DISK_GB=$(df -BG . 2>/dev/null | awk 'NR==2{print $4}' | sed 's/G//' || echo 0)
CPU_CORES=$(nproc 2>/dev/null || echo 1)

echo -e "  - CPU Cores: ${YELLOW}${CPU_CORES}${NC}"
echo -e "  - Total RAM: ${YELLOW}${TOTAL_RAM_GB} GB${NC}"
echo -e "  - Free Storage: ${YELLOW}${FREE_DISK_GB} GB${NC}"

if [ "$TOTAL_RAM_GB" -lt 16 ]; then
    echo -e "${YELLOW}[WARNING] Minimum recommended RAM for AOSP builds is 16GB (32GB recommended). Compilation may rely heavily on swap.${NC}"
fi

if [ "$FREE_DISK_GB" -lt 100 ]; then
    echo -e "${YELLOW}[WARNING] Recommended free disk space is at least 250-300 GB for AOSP tree + build artifacts.${NC}"
fi

# 2. Package Manager Audit & Installation
echo -e "\n${GREEN}[2/4] Installing Required Toolchain Packages...${NC}"

if command -v apt-get &> /dev/null; then
    echo -e "Updating apt repository indices..."
    sudo apt-get update -qq

    PACKAGES=(
        git-core gnupg flex bison build-essential zip curl zlib1g-dev
        gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev
        x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev
        libxml2-utils xsltproc unzip fontconfig openjdk-17-jdk python3
        rsync schedtool ccache libssl-dev bc liblz4-tool libncurses5
        pngcrush schedtool libxml2 gawk ninja-build
    )

    echo -e "Installing build dependencies via apt..."
    sudo apt-get install -y "${PACKAGES[@]}"
else
    echo -e "${YELLOW}[NOTICE] Non-Debian based package manager detected. Please ensure standard AOSP build tools are installed.${NC}"
fi

# 3. Android `repo` Binary Setup
echo -e "\n${GREEN}[3/4] Installing / Updating Google `repo` Tool...${NC}"
mkdir -p "$HOME/bin"
curl -s https://storage.googleapis.com/git-repo-downloads/repo > "$HOME/bin/repo"
chmod a+rx "$HOME/bin/repo"

if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/bin:$PATH"
    echo -e "  - Added $HOME/bin to PATH."
fi

# 4. Git Configuration & Cache Optimization
echo -e "\n${GREEN}[4/4] Optimizing Build Cache (ccache)...${NC}"
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 50G 2>/dev/null || echo -e "  - Note: ccache size configured to default."

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}  Host Build Environment Successfully Prepared!                ${NC}"
echo -e "${GREEN}  Next Step: Run 'bash scripts/sync_source.sh' to sync source. ${NC}"
echo -e "${GREEN}================================================================${NC}"
