#!/bin/bash
# TP-LINK WR842N V3 PrintServer - Download OpenWrt Sources Script

set -e

OPENWRT_DIR="$HOME/openwrt"
OPENWRT_BRANCH="openwrt-21.02"

echo "=== TP-LINK WR842N V3 PrintServer Build Environment Setup ==="
echo "Target: OpenWrt 21.02 for ar71xx/generic"
echo "============================================================"

# Create build directory
mkdir -p "$OPENWRT_DIR"
cd "$OPENWRT_DIR"

# Clone OpenWrt source if not exists
if [ ! -d ".git" ]; then
    echo "Cloning OpenWrt 21.02 source code..."
    git clone https://github.com/openwrt/openwrt.git -b "$OPENWRT_BRANCH" .
else
    echo "Updating OpenWrt source code..."
    git fetch origin
    git checkout "$OPENWRT_BRANCH"
    git pull origin "$OPENWRT_BRANCH"
fi

# Update and install feeds
echo "Updating feeds..."
./scripts/feeds update -a

echo "Installing feeds..."
./scripts/feeds install -a

# Create custom feeds for additional packages
echo "Setting up custom feeds..."
cat > feeds.conf << 'EOF'
src-git packages https://github.com/openwrt/packages.git^1f5c2b8f5b9b8d8c8d8c8d8c8d8c8d8c8d8c8d8
src-git luci https://github.com/openwrt/luci.git^1f5c2b8f5b9b8d8c8d8c8d8c8d8c8d8c8d8
src-git routing https://github.com/openwrt/feed/routing.git^1f5c2b8f5b9b8d8c8d8c8d8c8d8c8d8c8d8
src-git telephony https://github.com/openwrt/telephony.git^1f5c2b8f5b9b8d8c8d8c8d8c8d8c8d8c8d8
EOF

# Update feeds again with custom configuration
./scripts/feeds update -a
./scripts/feeds install -a

echo "=== Source download completed ==="
echo "OpenWrt directory: $OPENWRT_DIR"
echo "Next step: Copy configuration and start build"
echo "Run: make menuconfig"
