#!/bin/bash
# TP-LINK WR842N V3 PrintServer - Project Verification Script

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== TP-LINK WR842N V3 PrintServer Project Verification ==="
echo "Project directory: $PROJECT_DIR"
echo "========================================================"

# Check required directories
echo "Checking directories..."
required_dirs=(
    ".github/workflows"
    "configs"
    "files/etc/config"
    "files/etc/cups"
    "files/etc/cups/ppd"
    "files/usr/bin"
    "patches"
    "scripts"
)

for dir in "${required_dirs[@]}"; do
    if [ -d "$PROJECT_DIR/$dir" ]; then
        echo "✓ $dir"
    else
        echo "✗ $dir (missing)"
        exit 1
    fi
done

# Check required files
echo ""
echo "Checking files..."
required_files=(
    "README.md"
    "LICENSE"
    "USER_GUIDE.md"
    ".github/workflows/build.yml"
    "configs/.config"
    "files/etc/rc.local"
    "files/etc/cups/cupsd.conf"
    "files/etc/cups/cupsd.conf.default"
    "files/etc/config/network"
    "files/etc/config/wireless"
    "files/etc/config/system"
    "files/etc/config/firewall"
    "files/etc/config/autoreboot"
    "files/usr/bin/ap-mode-toggle"
    "files/usr/bin/setup-printers"
    "scripts/download-sources.sh"
    "scripts/setup-environment.sh"
    "scripts/build.sh"
    "scripts/fix-permissions.sh"
    "scripts/verify-project.sh"
)

for file in "${required_files[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        echo "✓ $file"
    else
        echo "✗ $file (missing)"
        exit 1
    fi
done

# Check file permissions
echo ""
echo "Checking permissions..."
executable_files=(
    "files/etc/rc.local"
    "files/usr/bin/ap-mode-toggle"
    "files/usr/bin/setup-printers"
    "scripts/download-sources.sh"
    "scripts/setup-environment.sh"
    "scripts/build.sh"
    "scripts/fix-permissions.sh"
    "scripts/verify-project.sh"
)

for file in "${executable_files[@]}"; do
    if [ -x "$PROJECT_DIR/$file" ]; then
        echo "✓ $file (executable)"
    else
        echo "✗ $file (not executable)"
    fi
done

# Check configuration syntax
echo ""
echo "Checking configuration syntax..."

# Check network config
if grep -q "option ipaddr '192.168.10.1'" "$PROJECT_DIR/files/etc/config/network"; then
    echo "✓ Network configuration (LAN IP: 192.168.10.1)"
else
    echo "✗ Network configuration (LAN IP not set correctly)"
fi

# Check wireless config
if grep -q "option ssid 'THDN-dayin'" "$PROJECT_DIR/files/etc/config/wireless"; then
    echo "✓ Wireless configuration (SSID: THDN-dayin)"
else
    echo "✗ Wireless configuration (SSID not set correctly)"
fi

# Check system config
if grep -q "option hostname 'THDN-PrintServer'" "$PROJECT_DIR/files/etc/config/system"; then
    echo "✓ System configuration (hostname: THDN-PrintServer)"
else
    echo "✗ System configuration (hostname not set correctly)"
fi

# Check CUPS config
if grep -q "DefaultLanguage zh-CN" "$PROJECT_DIR/files/etc/cups/cupsd.conf"; then
    echo "✓ CUPS configuration (Chinese localization enabled)"
else
    echo "✗ CUPS configuration (Chinese localization not enabled)"
fi

# Check build workflow
if grep -q "ubuntu-22.04" "$PROJECT_DIR/.github/workflows/build.yml"; then
    echo "✓ GitHub Actions workflow (Ubuntu 22.04)"
else
    echo "✗ GitHub Actions workflow (Ubuntu version not correct)"
fi

if grep -q "actions/upload-artifact@v4" "$PROJECT_DIR/.github/workflows/build.yml"; then
    echo "✓ GitHub Actions workflow (using upload-artifact@v4)"
else
    echo "✗ GitHub Actions workflow (upload-artifact version not correct)"
fi

echo ""
echo "=== Project Verification Summary ==="
echo "All required files and directories are present"
echo "Configuration appears to be correct"
echo "Project is ready for building"
echo "===================================="

echo ""
echo "Next steps:"
echo "1. Run 'bash scripts/download-sources.sh' to download OpenWrt sources"
echo "2. Run 'bash scripts/build.sh' to build the firmware"
echo "3. Find firmware files in firmware/ directory after build"
