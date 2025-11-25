#!/bin/bash
# Test script for scoring

echo "=== Testing Scoring Logic ==="
echo ""

../build.sh > /dev/null 2>&1

cat > /tmp/test_scoring.txt << 'EOF'
score
w
take tools
score
get pokey
score
get antic
score
drop pokey
get pokey
score
quit
y
EOF

echo "Running test..."
dfrotz ../panic.z3 < /tmp/test_scoring.txt > /tmp/scoring_output.txt 2>&1

echo "=== Test Results ==="
grep -A 2 "Score:" /tmp/scoring_output.txt | grep -v "Moves"

echo ""
echo "=== Detailed Analysis ==="
echo "Start Score: $(grep -m 1 "Score: 0" /tmp/scoring_output.txt)"
echo "After Tools (+3): $(grep "Score: 3" /tmp/scoring_output.txt)"
echo "After POKEY (+5): $(grep "Score: 8" /tmp/scoring_output.txt)"
echo "After ANTIC (+2): $(grep "Score: 10" /tmp/scoring_output.txt)"
echo "After re-taking POKEY (should stay 10): $(grep "Score: 10" /tmp/scoring_output.txt | tail -1)"

echo ""
# Check if messages appear
grep "You'll need these" /tmp/scoring_output.txt
grep "You carefully secure" /tmp/scoring_output.txt

if grep -q "Score: 10" /tmp/scoring_output.txt; then
    echo "✓ Scoring verification successful! Total 10 points."
else
    echo "✗ Scoring verification failed."
fi
