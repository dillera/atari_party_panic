# Testing Guide for Atari Party Panic

## Overview

This document describes the automated testing system for Atari Party Panic. The testing system follows **black box design principles** - testing player-visible behavior without depending on internal implementation details.

## Quick Start

```bash
# Run all tests
make test

# Or run directly
cd tests
./run_tests.sh

# Run specific test
cd tests
./run_tests.sh 05_complete_game
```

## Testing Architecture

### Black Box Testing Principles

**Primitive**: Test case = command sequence + expected output  
**Interface**: Test runner feeds commands to Z-machine interpreter, captures output  
**Black Box**: Game internals are hidden; only player-visible behavior is tested  
**Replaceable**: Game implementation can change if output remains consistent

### Directory Structure

```
tests/
├── run_tests.sh           # Main test runner
├── scripts/               # Test command scripts (.txt)
│   ├── 01_basic_navigation.txt
│   ├── 02_power_failure_trigger.txt
│   ├── 03_discover_bunker.txt
│   ├── 04_read_narrative.txt
│   ├── 05_complete_game.txt
│   └── 06_puzzle_requirements.txt
├── expected/              # Expected output for each test
│   └── [same names as scripts]
└── results/               # Actual output from test runs
    └── [generated during test runs]
```

## Test Suite

### Current Tests

| Test | Purpose | What It Verifies |
|------|---------|------------------|
| **01_basic_navigation** | Basic movement | All rooms accessible, descriptions correct |
| **02_power_failure_trigger** | Event system | Power failure triggers after 4 turns, doors lock |
| **03_discover_bunker** | Hidden puzzle | Rug reveals trapdoor, bunker accessible |
| **04_read_narrative** | Reading system | Logbook and diary have 5 entries each, sequential |
| **05_complete_game** | Victory condition | Full playthrough succeeds, score 50/50 |
| **06_puzzle_requirements** | Puzzle logic | Chip requires tools and power failure |

### Test Coverage

✅ **Covered:**
- Room navigation (N/S/E/W)
- Object interaction (take, examine, put)
- Puzzle requirements (tools, timing)
- Event triggers (power failure)
- Sequential reading systems
- Victory condition
- Door locking mechanics

⚠️ **Not Yet Covered:**
- Invalid commands (parser error handling)
- Edge cases (unusual command sequences)
- All object combinations
- Help system
- Save/restore functionality

## Creating New Tests

### 1. Write Command Script

Create a file in `tests/scripts/` with one command per line:

```bash
# tests/scripts/07_my_new_test.txt
look
north
examine rug
take logbook
read logbook
quit
y
```

**Important**: Always end with `quit` and `y` to exit cleanly.

### 2. Generate Baseline Output

Run the test to generate output:

```bash
cd tests
./run_tests.sh 07_my_new_test
```

This creates `results/07_my_new_test.txt`

### 3. Review Output

Check that the output is correct:

```bash
less results/07_my_new_test.txt
```

### 4. Approve Baseline

If the output is correct, copy it to expected:

```bash
cp results/07_my_new_test.txt expected/
```

### 5. Verify Test Passes

Run the test again to verify:

```bash
./run_tests.sh 07_my_new_test
```

Should show: `✓ PASS`

## Test Workflow

### During Development

1. **Make code changes** to your game
2. **Run tests**: `make test`
3. **If tests fail**:
   - Review the diff: `diff tests/expected/test.txt tests/results/test.txt`
   - If behavior changed intentionally: Update expected output
   - If behavior changed unintentionally: Fix the bug

### Before Committing

```bash
# Build and test
make clean
make
make test

# If all pass, commit
git add .
git commit -m "Your changes"
```

### Continuous Integration

Add to your CI pipeline:

```yaml
# .github/workflows/test.yml
- name: Build and Test
  run: |
    make
    make test
```

## Debugging Failed Tests

### View Differences

```bash
# Quick diff
diff tests/expected/test_name.txt tests/results/test_name.txt

# Side-by-side diff
diff -y tests/expected/test_name.txt tests/results/test_name.txt | less

# Visual diff (macOS)
opendiff tests/expected/test_name.txt tests/results/test_name.txt
```

### Common Failure Causes

1. **Intentional text changes**: Update expected output
2. **Bug introduced**: Fix the code
3. **Timing changes**: Event triggers at different turn
4. **State management**: Game state not properly reset

## Best Practices

### Test Design

- ✅ **One concept per test**: Each test verifies one feature or puzzle
- ✅ **Independent tests**: Tests don't depend on each other
- ✅ **Clear naming**: Use numbered prefixes for logical order
- ✅ **Document purpose**: Add comments in this file

### Test Maintenance

- ✅ **Version control**: Commit both scripts and expected outputs
- ✅ **Update carefully**: Only update expected output when behavior changes intentionally
- ✅ **Document changes**: Note why expected output changed in commit message
- ✅ **Review diffs**: Always review what changed before approving

### Test Coverage

- ✅ **Happy path**: Normal puzzle solutions
- ✅ **Error cases**: Invalid commands, wrong order
- ✅ **Edge cases**: Boundary conditions
- ✅ **Regression**: Add test for every bug fixed

## Advanced Testing

### Performance Testing

Time test execution:

```bash
time make test
```

### Regression Testing

When fixing a bug:

1. Create test that reproduces the bug
2. Verify test fails with current code
3. Fix the bug
4. Verify test now passes
5. Commit both fix and test

### Fuzzing (Future Enhancement)

Generate random commands to test parser robustness:

```bash
# Generate random commands
for i in {1..100}; do
    shuf -n 1 /usr/share/dict/words
done > tests/scripts/fuzz_test.txt
echo "quit" >> tests/scripts/fuzz_test.txt
echo "y" >> tests/scripts/fuzz_test.txt

# Run and check for crashes
./run_tests.sh fuzz_test
```

## Technical Details

### Test Runner Implementation

The test runner (`run_tests.sh`) uses:

- **dfrotz**: "Dumb" frotz interpreter for clean text output
- **diff**: Compares expected vs actual output
- **bash**: Orchestrates test execution

### Output Format

Tests use `dfrotz` with:
- `-m`: Disable MORE prompts
- `-w 1000`: Wide screen to avoid line wrapping

This produces clean, consistent output suitable for comparison.

### Exit Codes

- `0`: All tests passed
- `1`: One or more tests failed
- `2`: Tests generated but not yet approved

## Limitations

### What This Tests

✅ Player-visible behavior  
✅ Puzzle logic and requirements  
✅ Room navigation  
✅ Object interactions  
✅ Victory/failure conditions  
✅ Text output  

### What This Doesn't Test

❌ Internal state (unless visible to player)  
❌ Performance  
❌ Memory usage  
❌ Parser edge cases (requires fuzzing)  
❌ Save/restore functionality  

## Future Enhancements

- [ ] Add JSON test format for structured assertions
- [ ] Add timing assertions (max turns to solve)
- [ ] Add score assertions at checkpoints
- [ ] Add inventory state verification
- [ ] Add parallel test execution
- [ ] Add test coverage reporting
- [ ] Add CI/CD integration (GitHub Actions)
- [ ] Add fuzzing for parser testing
- [ ] Add performance benchmarks

## Troubleshooting

### dfrotz not found

```bash
brew install frotz
```

### Game file not found

```bash
make clean
make
```

### Tests fail after refactoring

This is expected! The tests verify behavior:

1. Review the diff to see what changed
2. If behavior changed intentionally: Update expected output
3. If behavior changed unintentionally: Fix the bug

### Inconsistent output

If output varies between runs (shouldn't happen with Z-machine):

```bash
# Run test multiple times
for i in {1..5}; do
    ./run_tests.sh test_name
done
```

## Integration with Development Workflow

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
make test
if [ $? -ne 0 ]; then
    echo "Tests failed. Commit aborted."
    exit 1
fi
```

### Make Targets

```bash
make test          # Run all tests
make              # Build game
make build        # Create disk image
make clean        # Remove artifacts
```

## Conclusion

This testing system provides:

- **Confidence**: Know your changes don't break existing functionality
- **Documentation**: Tests serve as executable specifications
- **Regression prevention**: Bugs stay fixed
- **Refactoring safety**: Change implementation without fear

The black box approach ensures tests remain valid even as internal implementation changes, as long as player-visible behavior stays consistent.
