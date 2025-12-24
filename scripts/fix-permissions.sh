#!/bin/bash
# TP-LINK WR842N V3 PrintServer - Fix File Permissions Script

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Fixing file permissions ==="

# Make scripts executable
chmod +x "$PROJECT_DIR/scripts/"*.sh
chmod +x "$PROJECT_DIR/files/usr/bin/"*

# Fix permissions for configuration files
chmod 644 "$PROJECT_DIR/files/etc/config/"*
chmod 644 "$PROJECT_DIR/files/etc/cups/"*
chmod 644 "$PROJECT_DIR/files/etc/cups/ppd/"*

# Make rc.local executable
chmod 755 "$PROJECT_DIR/files/etc/rc.local"

# Make AP mode toggle script executable
chmod 755 "$PROJECT_DIR/files/usr/bin/ap-mode-toggle"
chmod 755 "$PROJECT_DIR/files/usr/bin/setup-printers"

echo "File permissions fixed successfully!"
