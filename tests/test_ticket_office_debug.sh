#!/bin/bash
# Debug test for Ticket Office objects

echo "=== Debugging Ticket Office Objects ==="
echo ""

../build.sh > /dev/null 2>&1

cat > /tmp/debug_test.txt << 'EOF'
verbose
w
look
x disk
x pokey
x pokey chip
x chip
take disk
take pokey
take pokey chip
take chip
get disk
get pokey
get chip
quit
y
EOF

echo "Commands being sent:"
echo "  x disk / x pokey / x chip"
echo "  take disk / take pokey / take chip"
echo "  get disk / get pokey / get chip"
echo ""

dfrotz ../panic.z3 < /tmp/debug_test.txt 2>&1 | grep -v DEBUG > /tmp/debug_output.txt

echo "=== Parser Responses ==="
# Show what happens with examine commands
grep -A 2 "x disk\|x pokey\|x chip" /tmp/debug_output.txt | head -20

echo ""
echo "=== Take/Get Responses ==="
# Show what happens with take/get commands
grep -B 1 -A 1 "take\|get" /tmp/debug_output.txt | head -20

echo ""
echo "Full output saved to: /tmp/debug_output.txt"
