#!/bin/bash
# Test script for endgame logic (Tools + POKEY installation)

echo "=== Testing Endgame Logic ==="
echo ""

./build.sh > /dev/null 2>&1

cat > /tmp/test_endgame.txt << 'EOF'
! Move to ticket office
w
! Get tools and pokey
take tools
get pokey
inventory
! Move to Bunker
e
n
move rug
d
! Wait for power failure (needs ~5 turns)
z
z
z
z
z
! Try to install pokey (should work if we have tools)
put pokey in computer
quit
y
EOF

echo "Running test..."
dfrotz panic.z3 < /tmp/test_endgame.txt > /tmp/endgame_output.txt 2>&1

echo "=== Test Results ==="
grep -A 5 "Ticket Office" /tmp/endgame_output.txt | head -10
echo "..."
grep -A 5 "taking inventory" /tmp/endgame_output.txt
echo "..."
grep -A 10 "put pokey in computer" /tmp/endgame_output.txt

echo ""
if grep -q "You've successfully restored the station's systems" /tmp/endgame_output.txt; then
    echo "✓ VICTORY: Successfully installed POKEY and won the game!"
else
    echo "✗ FAILED: Did not trigger victory condition."
    echo "Check /tmp/endgame_output.txt for details."
fi
