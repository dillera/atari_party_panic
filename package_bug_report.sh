#!/bin/bash
# Package minimal test case for upstream bug report

echo "=== Packaging PunyInform Bug Report ==="
echo ""

PACKAGE_DIR="punyinform_bug_report_$(date +%Y%m%d)"
mkdir -p "$PACKAGE_DIR"

echo "Creating package directory: $PACKAGE_DIR"

# Copy core files
cp minimal_test.inf "$PACKAGE_DIR/"
cp test_minimal.sh "$PACKAGE_DIR/"
cp BUG_REPORT_PUNYINFORM.md "$PACKAGE_DIR/"
cp MINIMAL_TEST_README.md "$PACKAGE_DIR/README.md"

# Create a sample output file
echo "Running test to capture output..."
./test_minimal.sh > "$PACKAGE_DIR/test_output.txt" 2>&1

# Create submission checklist
cat > "$PACKAGE_DIR/SUBMISSION_CHECKLIST.md" << 'EOF'
# Submission Checklist

## Files Included
- [x] minimal_test.inf - 56-line minimal reproduction case
- [x] test_minimal.sh - Automated test script  
- [x] BUG_REPORT_PUNYINFORM.md - Detailed bug report
- [x] README.md - Quick start guide
- [x] test_output.txt - Sample output showing bug
- [x] SUBMISSION_CHECKLIST.md - This file

## Information to Include When Reporting

### Environment
- PunyInform Version: v6.1.1 DR
- Inform Compiler: 6.44 (11th September 2025)
- Z-Machine Version: Z3
- Platform: macOS
- Compiler Flags: -v3 +lib -Cu

### Bug Summary
Take, Get, Drop, and Inventory commands produce no text output.

### How to Reproduce
1. Compile: inform -v3 +lib -Cu minimal_test.inf minimal_test.z3
2. Run: dfrotz minimal_test.z3
3. Try: inventory, take red ball, inventory
4. Observe: All commands produce blank lines instead of expected messages

### Where to Report
- PunyInform GitHub: https://github.com/johanberntsson/PunyInform/issues
- IntFiction Forum: https://intfiction.org/
- Inform 6 Discord/Community channels

### Tested Fixes (None Worked)
- Added explicit `has;` clauses
- Simplified descriptions  
- Added transparent attribute to containers
- Removed ambiguous names
- Verified include order
- Checked for library conflicts

## Package Created
Date: $(date)
Version: 1.0
EOF

# Create archive
echo "Creating archive..."
tar -czf "${PACKAGE_DIR}.tar.gz" "$PACKAGE_DIR"

echo ""
echo "✓ Package created successfully!"
echo ""
echo "Package contents:"
ls -lh "$PACKAGE_DIR"
echo ""
echo "Archive created: ${PACKAGE_DIR}.tar.gz"
echo "Size: $(du -h ${PACKAGE_DIR}.tar.gz | cut -f1)"
echo ""
echo "To submit:"
echo "  1. Extract: tar -xzf ${PACKAGE_DIR}.tar.gz"
echo "  2. Read: ${PACKAGE_DIR}/README.md"
echo "  3. Test: cd ${PACKAGE_DIR} && ./test_minimal.sh"
echo "  4. Report: Use BUG_REPORT_PUNYINFORM.md as template"
echo ""
