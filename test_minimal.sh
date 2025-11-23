#!/bin/bash
# Test script for minimal bug reproduction

echo "=== Compiling Minimal Test Case ==="
/usr/local/bin/inform -v3 +lib -Cu minimal_test.inf minimal_test.z3

if [ ! -f minimal_test.z3 ]; then
    echo "✗ Compilation failed"
    exit 1
fi

echo ""
echo "=== Running Automated Test ==="
cat > /tmp/minimal_test_commands.txt << 'EOF'
inventory
take red ball
inventory
drop red ball
inventory
take blue ball
inventory
quit
y
EOF

dfrotz minimal_test.z3 < /tmp/minimal_test_commands.txt > /tmp/minimal_test_output.txt 2>&1

echo "Commands sent:"
echo "  1. inventory (expected: 'You are carrying nothing.')"
echo "  2. take red ball (expected: 'Taken.')"
echo "  3. inventory (expected: 'You are carrying: a red ball')"
echo "  4. drop red ball (expected: 'Dropped.')"
echo "  5. inventory (expected: 'You are carrying nothing.')"
echo "  6. take blue ball (expected: 'Taken.')"
echo "  7. inventory (expected: 'You are carrying: a blue ball')"
echo ""

echo "=== Actual Output ==="
grep -A 2 "Please test" /tmp/minimal_test_output.txt | tail -1
echo ""
echo "After 'inventory' command:"
grep -A 3 "Test Room" /tmp/minimal_test_output.txt | tail -3
echo ""
echo "After 'take red ball' command:"
grep -A 2 "Moves: 2" /tmp/minimal_test_output.txt | tail -2
echo ""
echo "After second 'inventory' command:"
grep -A 2 "Moves: 3" /tmp/minimal_test_output.txt | tail -2
echo ""

echo "=== Full Output ===" 
echo "(saved to /tmp/minimal_test_output.txt)"
echo ""
cat /tmp/minimal_test_output.txt | tail -50
