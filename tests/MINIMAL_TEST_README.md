# PunyInform Minimal Test Case - Take/Inventory Bug

## Quick Start

```bash
# Compile the test
/usr/local/bin/inform -v3 +lib -Cu minimal_test.inf minimal_test.z3

# Run automated test
chmod +x test_minimal.sh
./test_minimal.sh

# Or run interactively
dfrotz minimal_test.z3
```

## What This Tests

This minimal 56-line PunyInform game demonstrates a bug where:
- `inventory` command produces no output
- `take` commands produce no output (no "Taken." message)
- `drop` commands produce no output (no "Dropped." message)

## Test Environment

- **PunyInform**: v6.1.1 DR
- **Inform**: 6.44
- **Z-Machine**: v3
- **Platform**: macOS
- **Interpreter**: dfrotz

## File Structure

```
minimal_test.inf           - 56-line minimal game demonstrating bug
test_minimal.sh            - Automated test script
BUG_REPORT_PUNYINFORM.md  - Complete bug report
MINIMAL_TEST_README.md    - This file
```

## The Test Game

**Objects:**
- `redBall` - Simple takeable object in room
- `blueBall` - Takeable object inside container
- `simpleBox` - Open transparent container

**Test Sequence:**
1. `inventory` - Should show "You are carrying nothing."
2. `take red ball` - Should show "Taken."
3. `inventory` - Should list red ball
4. `drop red ball` - Should show "Dropped."
5. `take blue ball` - Should show "Taken."
6. `inventory` - Should list blue ball

**Actual Result:**
All commands produce blank output.

## Expected vs Actual

### Expected
```
> inventory
You are carrying nothing.

> take red ball
Taken.

> inventory
You are carrying:
  a red ball
```

### Actual
```
> inventory
[blank line]

> take red ball
[blank line]

> inventory
[blank line]
```

## Notes

- Turn counter increments correctly (commands are being processed)
- `examine` commands work fine
- Room descriptions show objects correctly
- No compilation errors or warnings
- Bug is consistent across all takeable objects

## For Reporting Upstream

This test case can be submitted to:
- PunyInform GitHub issues
- IntFiction forums
- Inform 6 community channels

Include:
1. `minimal_test.inf` (the source)
2. `BUG_REPORT_PUNYINFORM.md` (detailed report)
3. Output from `test_minimal.sh` (demonstration)

## License

This test case is public domain. Use freely for bug reporting and debugging.
