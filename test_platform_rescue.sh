#!/bin/bash
# Test script for Platform Rescue logic

echo "=== Testing Platform Rescue ==="
echo ""

./build.sh > /dev/null 2>&1

cat > /tmp/test_rescue.txt << 'EOF'
e
z
z
z
z
z
look
quit
y
EOF

echo "Running test..."
dfrotz panic.z3 < /tmp/test_rescue.txt > /tmp/rescue_output.txt 2>&1

echo "=== Test Results ==="
grep -A 5 "station master grabs you" /tmp/rescue_output.txt

echo ""
echo "Final Location Check:"
# Look for "Lobby" or "Train Station" in the final description
tail -20 /tmp/rescue_output.txt | grep "Lobby"

if grep -q "station master grabs you" /tmp/rescue_output.txt; then
    if grep -q "Lobby" /tmp/rescue_output.txt; then
        echo "✓ RESCUE SUCCESS: Player moved to Lobby."
    else
        echo "⚠ PARTIAL SUCCESS: Message seen but location might be wrong."
    fi
else
    echo "✗ RESCUE FAILED: Message not found."
fi
