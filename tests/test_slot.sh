#!/bin/bash
# Test script for putting POKEY in the SLOT specifically

echo "=== Testing 'Put POKEY in SLOT' ==="
echo ""

../build.sh > /dev/null 2>&1

cat > /tmp/test_slot.txt << 'EOF'
w
take tools
get pokey
e
n
move rug
d
z
z
z
z
z
put pokey in slot
look in slot
quit
y
EOF

echo "Running test..."
dfrotz ../panic.z3 < /tmp/test_slot.txt > /tmp/slot_output.txt 2>&1

echo "=== Test Results ==="
grep -A 10 "put pokey in slot" /tmp/slot_output.txt

if grep -q "You've successfully restored" /tmp/slot_output.txt; then
    echo "✓ VICTORY via SLOT"
else
    echo "✗ FAIL via SLOT"
fi
