#!/bin/bash
# Build script for Atari Party Panic
# Compiles panic.inf to panic.z3

set -e  # Exit on error

echo "=== Atari Party Panic Build Script ==="
echo ""

# Remove old build
if [ -f panic.z3 ]; then
    echo "Removing old panic.z3..."
    rm -f panic.z3
fi

# Build the game
echo "Compiling panic.inf..."
/usr/local/bin/inform -v3 +lib -Cu panic.inf panic.z3

# Check if build succeeded
if [ -f panic.z3 ]; then
    SIZE=$(stat -f%z panic.z3 2>/dev/null || stat -c%s panic.z3 2>/dev/null)
    echo ""
    echo "✓ Build successful!"
    echo "  Output: panic.z3 (${SIZE} bytes)"
    echo ""
    echo "To play: dfrotz panic.z3"
    exit 0
else
    echo ""
    echo "✗ Build failed!"
    exit 1
fi
