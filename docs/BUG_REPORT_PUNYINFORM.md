# PunyInform Bug Report: Take and Inventory Commands Produce No Output

## Summary
The `Take`, `Get`, `Drop`, and `Inventory` actions produce no text output when executed. Commands are accepted and processed (turn counter increments), but no feedback messages appear (no "Taken.", "Dropped.", or inventory list).

## Environment
- **System**: macOS
- **Inform Compiler**: 6.44 (11th September 2025)
- **PunyInform Version**: v6.1.1 DR
- **Z-Machine Version**: Z3
- **Compiler Flags**: `-v3 +lib -Cu`
- **Interpreter**: dfrotz (Frotz 2.54)

## Bug Reproduction

### Minimal Test Case
A complete minimal test case is provided in `minimal_test.inf` (56 lines).

**To reproduce:**
```bash
# Compile
/usr/local/bin/inform -v3 +lib -Cu minimal_test.inf minimal_test.z3

# Run
dfrotz minimal_test.z3

# Try commands:
> inventory
> take red ball
> inventory
> drop red ball
```

### Expected Behavior
```
> inventory
You are carrying nothing.

> take red ball
Taken.

> inventory
You are carrying:
  a red ball

> drop red ball
Dropped.
```

### Actual Behavior
```
> inventory
[blank - no output]

> take red ball
[blank - no output]

> inventory
[blank - no output]

> drop red ball
[blank - no output]
```

## Observations

1. **Commands are processed**: Turn counter increments correctly
2. **Parsing works**: `Examine` commands work fine and show descriptions
3. **Objects visible**: Room listings show objects correctly
4. **All take actions fail**: Both direct take and take-from-container fail
5. **No error messages**: Silent failure with no diagnostic output
6. **Consistent across objects**: Simple objects, objects in containers, all exhibit same behavior

## Test Results

### What Works ✅
- Room navigation
- Examine commands (`x red ball` shows description)
- Room descriptions
- Object listings in room descriptions
- Custom object handlers (tested in main game)

### What Fails ❌
- `Take` command (no "Taken." message)
- `Get` command (no "Taken." message)
- `Drop` command (no "Dropped." message)  
- `Inventory`/`I` command (no inventory list)
- All standard inventory-related actions

## Code Structure

The minimal test includes:
- Standard PunyInform includes (`lib/globals.h`, `lib/puny.h`)
- One simple room with `light` attribute
- Two takeable objects with no special attributes (just `has;`)
- One container with `container open transparent` attributes
- Standard `Initialise` routine setting location

No custom LibraryMessages, no action overrides, no unusual code.

## Attempted Fixes (None Successful)

1. ✅ Added explicit empty `has;` clauses to objects
2. ✅ Changed description routines to simple strings
3. ✅ Added `transparent` attribute to containers
4. ✅ Removed ambiguous object names
5. ✅ Tested with objects both in/out of containers
6. ✅ Verified proper include order
7. ✅ Checked for conflicting library extensions (none present)

## Files Included

1. **minimal_test.inf** - Complete 56-line minimal reproduction case
2. **test_minimal.sh** - Automated test script showing the bug
3. **BUG_REPORT_PUNYINFORM.md** - This document

## Questions for Maintainers

1. Is there a required configuration for inventory actions in PunyInform?
2. Could this be related to a specific platform-specific issue?
3. Are we missing a required library include or constant definition?
4. Has this behavior been reported before?

## Additional Context

This bug was discovered while developing "Atari Party Panic", a larger IF game. The bug affects ALL takeable objects in the game, making inventory management completely non-functional. The game compiles without errors or warnings.

## Request

We would appreciate guidance on:
- Whether this is a known issue
- If there's a configuration we're missing
- Workarounds or fixes
- Whether this might be an installation/environment issue

Thank you for maintaining PunyInform!
