#!/bin/bash
# TP-LINK WR842N V3 PrintServer - Main Build Script

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENWRT_DIR="$HOME/openwrt"
BUILD_LOG="$PROJECT_DIR/build.log"

echo "=== TP-LINK WR842N V3 PrintServer Firmware Build ==="
echo "Project: $PROJECT_DIR"
echo "OpenWrt: $OPENWRT_DIR"
echo "Log file: $BUILD_LOG"
echo "===================================================="

# Check prerequisites
if ! command -v make &> /dev/null; then
    echo "Error: make is not installed"
    exit 1
fi

if ! command -v gcc &> /dev/null; then
    echo "Error: gcc is not installed"
    exit 1
fi

# Setup environment
echo "Setting up build environment..."
cd "$PROJECT_DIR"
bash scripts/setup-environment.sh

# Start build
echo "Starting build process..."
cd "$OPENWRT_DIR"

# Clean previous build if requested
if [ "$1" == "clean" ]; then
    echo "Cleaning previous build..."
    make clean
fi

# Download sources
echo "Downloading package sources..."
make -j$(nproc) download V=s 2>&1 | tee -a "$BUILD_LOG"

# Build firmware
echo "Building firmware..."
make -j$(nproc) V=s 2>&1 | tee -a "$BUILD_LOG"

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "Build completed successfully!"
    
    # Copy firmware files
    FIRMWARE_DIR="$PROJECT_DIR/firmware"
    mkdir -p "$FIRMWARE_DIR"
    
    echo "Copying firmware files..."
    cp bin/target/linux/ath79/generic/*842n*v3*sysupgrade.bin "$FIRMWARE_DIR/" 2>/dev/null || true
    cp bin/target/linux/ath79/generic/*842n*v3*factory.bin "$FIRMWARE_DIR/" 2>/dev/null || true
    
    # Rename files for clarity
    cd "$FIRMWARE_DIR"
    for file in *842n*v3*sysupgrade.bin; do
        if [ -f "$file" ]; then
            mv "$file" "openwrt-ar71xx-generic-tl-wr842n-v3-squashfs-sysupgrade.bin"
        fi
    done
    
    for file in *842n*v3*factory.bin; do
        if [ -f "$file" ]; then
            mv "$file" "openwrt-ar71xx-generic-tl-wr842n-v3-squashfs-factory.bin"
        fi
    done
    
    echo "Firmware files copied to: $FIRMWARE_DIR"
    ls -la "$FIRMWARE_DIR"
    
    # Calculate checksums
    echo "Calculating checksums..."
    cd "$FIRMWARE_DIR"
    md5sum *.bin > checksums.md5
    sha256sum *.bin > checksums.sha256
    
    echo "Build process completed!"
    echo "Firmware files:"
    echo "- sysupgrade.bin: For online upgrades"
    echo "- factory.bin: For initial flashing"
    echo "- Checksums: checksums.md5, checksums.sha256"
    
else
    echo "Build failed! Check $BUILD_LOG for details"
    exit 1
fi
