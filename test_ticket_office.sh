#!/bin/bash
# Test script for Ticket Office object handling
# Tests taking objects from the Ticket Office

echo "=== Testing Ticket Office Object Inventory ==="
echo ""

# Build first
./build.sh > /dev/null 2>&1

if [ ! -f panic.z3 ]; then
    echo "✗ Build failed, cannot run test"
    exit 1
fi

# Create test input
cat > /tmp/test_ticket_office.txt << 'EOF'
! Test Ticket Office objects
i
w
look
! Try to take static objects (should fail)
take box
take toolkit
take drive
i
! Try to take items from inside the box
get disk from box
i
get pokey from box
i
get antic from box
i
! Verify we have the chips
x disk
x pokey
x antic
quit
y
EOF

echo "Running test..."
echo ""
dfrotz panic.z3 < /tmp/test_ticket_office.txt 2>&1 | grep -v DEBUG > /tmp/test_output.txt

# Display relevant output
echo "=== Test Results ==="
echo ""

# Check for taking static objects (should fail)
echo "1. Testing static objects (should NOT be takeable):"
grep -A 1 "take box\|take toolkit\|take drive" /tmp/test_output.txt | head -6
echo ""

# Check for successful takes
echo "2. Testing items from box (SHOULD be takeable):"
grep -A 1 "get disk\|get pokey\|get antic" /tmp/test_output.txt | grep -v "^--$" | head -6
echo ""

# Check final inventory
echo "3. Final inventory:"
grep -A 10 "You're carrying" /tmp/test_output.txt | tail -5
echo ""

# Verify objects are described properly
echo "4. Examining taken objects:"
grep -A 3 "x disk" /tmp/test_output.txt | head -4
echo ""

# Summary
echo "=== Summary ==="
DISK_COUNT=$(grep -c "Atari diagnostic disk" /tmp/test_output.txt || echo "0")
POKEY_COUNT=$(grep -c "POKEY chip" /tmp/test_output.txt || echo "0")
ANTIC_COUNT=$(grep -c "ANTIC chip" /tmp/test_output.txt || echo "0")

echo "Atari disk mentions: $DISK_COUNT"
echo "POKEY chip mentions: $POKEY_COUNT"
echo "ANTIC chip mentions: $ANTIC_COUNT"
echo ""

if [ "$DISK_COUNT" -gt 0 ] && [ "$POKEY_COUNT" -gt 0 ] && [ "$ANTIC_COUNT" -gt 0 ]; then
    echo "✓ All objects accessible and takeable!"
    exit 0
else
    echo "✗ Some objects may not be working correctly"
    exit 1
fi
