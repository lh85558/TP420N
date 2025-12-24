#!/bin/bash
# TP-LINK WR842N V3 PrintServer - Download OpenWrt Sources Script

set -e

OPENWRT_DIR="$HOME/openwrt"
OPENWRT_BRANCH="openwrt-21.02"

echo "=== TP-LINK WR842N V3 PrintServer Build Environment Setup ==="
echo "Target: OpenWrt 21.02 for linux/ath79/generic"
echo "============================================================"

# Create build directory
mkdir -p "$OPENWRT_DIR"
cd "$OPENWRT_DIR"

# Clone OpenWrt source if not exists
if [ ! -d ".git" ]; then
    echo "Cloning OpenWrt 21.02 source code..."
    git clone https://gitcode.com/lh85558.git -b "$OPENWRT_BRANCH" .
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
src-git packages https://gitcode.com/lh85558/packages.git^1f5c2b8f5b9b8d8c8d8c8d8c8d8c8d8c8d8c8d8
src-git luci https://gitcode.com/lh85558/luci.git^1f5c2b8f5b9b8d8c8d8c8d8c8d8c8d8c8d8
src-git routing https://gitcode.com/lh85558/feed/routing.git^1f5c2b8f5b9b8d8c8d8c8d8c8d8c8d8c8d8
src-git telephony https://gitcode.com/lh85558/telephony.git^1f5c2b8f5b9b8d8c8d8c8d8c8d8c8d8c8d8
EOF

# Update feeds again with custom configuration
./scripts/feeds update -a
./scripts/feeds install -a

echo "=== Source download completed ==="
echo "OpenWrt directory: $OPENWRT_DIR"
echo "Next step: Copy configuration and start build"
echo "Run: make menuconfig"
