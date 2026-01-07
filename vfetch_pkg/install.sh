#!/bin/sh
# Simple installation script for vfetch

set -e

if [ "$EUID" -eq 0 ]; then
    BINDIR="/usr/local/bin"
else
    echo "Please run as root or with sudo"
    exit 1
fi

echo "Installing vfetch to $BINDIR..."

# Copy the binary
cp vfetch $BINDIR/vfetch
chmod +x $BINDIR/vfetch

echo "vfetch installed successfully!"
echo "Run 'vfetch' to display system information."