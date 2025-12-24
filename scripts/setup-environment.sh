#!/bin/bash
# TP-LINK WR842N V3 PrintServer - Environment Setup Script

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENWRT_DIR="$HOME/openwrt"

echo "=== TP-LINK WR842N V3 PrintServer Environment Setup ==="
echo "Project directory: $PROJECT_DIR"
echo "OpenWrt directory: $OPENWRT_DIR"
echo "======================================================"

# Check if OpenWrt directory exists
if [ ! -d "$OPENWRT_DIR" ]; then
    echo "Error: OpenWrt directory not found!"
    echo "Please run download-sources.sh first"
    exit 1
fi

cd "$OPENWRT_DIR"

# Copy project configuration
echo "Copying project configuration..."
cp "$PROJECT_DIR/configs/.config" ./
cp -r "$PROJECT_DIR/files" ./
cp -r "$PROJECT_DIR/patches" ./

# Apply patches if any exist
if [ -d "patches" ] && [ "$(ls -A patches/*.patch 2>/dev/null)" ]; then
    echo "Applying patches..."
    for patch in patches/*.patch; do
        if [ -f "$patch" ]; then
            echo "Applying patch: $(basename "$patch")"
            patch -p1 < "$patch" || echo "Warning: Failed to apply $patch"
        fi
    done
fi

# Set up build environment
echo "Setting up build environment..."
export FORCE_UNSAFE_CONFIGURE=1

# Configure the build
echo "Configuring build..."
make defconfig

# Display configuration summary
echo "=== Build Configuration Summary ==="
echo "Target: $(grep CONFIG_TARGET= .config | head -1)"
echo "Target profile: $(grep CONFIG_TARGET_.*=y .config | grep -v CONFIG_TARGET_ALL | head -1)"
echo "==================================="

echo "Environment setup completed!"
echo "Next steps:"
echo "1. Run 'make menuconfig' to customize configuration (optional)"
echo "2. Run 'make -j\$(nproc)' to build the firmware"
echo "3. Find the firmware files in bin/targets/ar71xx/generic/"
