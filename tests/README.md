# Automated Testing for Atari Party Panic

## Overview

This directory contains automated tests for verifying game functionality. Tests use **scripted playthrough** - feeding commands to the Z-machine interpreter and verifying outputs.

## Architecture

```
tests/
├── run_tests.sh        # Test runner script
├── scripts/            # Test command scripts (.txt files)
├── expected/           # Expected output for each test
└── results/            # Actual output from test runs
```

### Black Box Testing Approach

- **Primitive**: Test case = command sequence + expected output
- **Interface**: Test runner feeds commands via stdin, captures stdout
- **Black Box**: Game internals hidden, only test player-visible behavior
- **Replaceable**: Can swap game implementation if output matches

## Prerequisites

Install frotz (Z-machine interpreter):
```bash
brew install frotz
```

Build the game:
```bash
make
```

## Running Tests

### Run all tests:
```bash
cd tests
./run_tests.sh
```

### Run specific test:
```bash
cd tests
./run_tests.sh 01_basic_navigation
```

## Test Scenarios

### 01_basic_navigation
**Purpose**: Verify basic movement and room descriptions  
**Tests**: N/S/E/W movement, look, inventory  
**Expected**: All rooms accessible, descriptions display correctly

### 02_power_failure_trigger
**Purpose**: Verify power failure event triggers correctly  
**Tests**: Wait 4 turns, check event fires, verify doors lock  
**Expected**: Power failure after turn 4, platform becomes inaccessible

### 03_discover_bunker
**Purpose**: Verify hidden bunker discovery puzzle  
**Tests**: Find rug, pull rug, reveal trapdoor, enter bunker  
**Expected**: Trapdoor revealed, bunker accessible

### 04_read_narrative
**Purpose**: Verify logbook and diary reading systems  
**Tests**: Take books, read multiple times, verify progression  
**Expected**: 5 entries each, sequential reading, completion message

### 05_complete_game
**Purpose**: Full playthrough - verify victory condition  
**Tests**: Get chip and tools, trigger power failure, install chip  
**Expected**: Game completes with victory message, score 50/50

### 06_puzzle_requirements
**Purpose**: Verify puzzle requirement enforcement  
**Tests**: Try to install chip without tools, before power failure  
**Expected**: Appropriate error messages, chip only works when conditions met

## Creating New Tests

### 1. Create command script
Create a new file in `scripts/` with commands (one per line):

```
tests/scripts/my_test.txt
```

Example:
```
look
north
take object
quit
y
```

### 2. Generate expected output
Run the test once to generate output:
```bash
./run_tests.sh my_test
```

This creates `results/my_test.txt`

### 3. Review and approve
Review the output. If correct, copy to expected:
```bash
cp results/my_test.txt expected/my_test.txt
```

### 4. Run regression test
Now the test will verify against expected output:
```bash
./run_tests.sh my_test
```

## Continuous Integration

Add to your build process:
```bash
make && cd tests && ./run_tests.sh
```

This ensures all tests pass before deployment.

## Test Output Format

- ✓ **PASS**: Output matches expected
- ✗ **FAIL**: Output differs from expected
- ⚠ **NO EXPECTED**: No expected output file (first run)

## Debugging Failed Tests

When a test fails:
```bash
# View the difference
diff tests/expected/test_name.txt tests/results/test_name.txt

# Or use a visual diff tool
opendiff tests/expected/test_name.txt tests/results/test_name.txt
```

## Best Practices

### Test Organization
- **One concept per test**: Each test verifies one puzzle or feature
- **Independent tests**: Tests don't depend on each other
- **Clear naming**: Use numbered prefixes for execution order

### Test Coverage
- **Happy path**: Normal puzzle solutions
- **Error cases**: Invalid commands, wrong order
- **Edge cases**: Boundary conditions, unusual sequences
- **Regression**: Tests for fixed bugs

### Maintenance
- **Update expected output**: When game text changes intentionally
- **Version control**: Commit both scripts and expected outputs
- **Document changes**: Note why expected output changed

## Integration with Makefile

Add to your Makefile:
```makefile
test: panic.z3
	cd tests && ./run_tests.sh

.PHONY: test
```

Then run:
```bash
make test
```

## Limitations

### What This Tests
- ✓ Player-visible behavior
- ✓ Puzzle logic and requirements
- ✓ Room navigation
- ✓ Object interactions
- ✓ Victory/failure conditions
- ✓ Text output

### What This Doesn't Test
- ✗ Internal state (unless visible to player)
- ✗ Performance
- ✗ Memory usage
- ✗ Parser edge cases (requires fuzzing)

## Advanced Testing

### Fuzzing
For parser testing, consider adding random command generation:
```bash
# Generate random commands
for i in {1..100}; do
    echo "$(shuf -n 1 /usr/share/dict/words)" >> fuzz_test.txt
done
echo "quit" >> fuzz_test.txt
echo "y" >> fuzz_test.txt

frotz panic.z3 < fuzz_test.txt
```

### Performance Testing
Time test execution:
```bash
time ./run_tests.sh
```

### Coverage Analysis
Track which rooms/objects are tested:
```bash
grep -h "look\|examine\|take" scripts/*.txt | sort | uniq -c
```

## Troubleshooting

### Frotz not found
```bash
brew install frotz
```

### Game file not found
```bash
cd .. && make
```

### Tests fail after refactoring
This is expected! Review the diff:
- If behavior changed intentionally: Update expected output
- If behavior changed unintentionally: Fix the bug

### Inconsistent output
Some Z-machine interpreters add extra whitespace. Use:
```bash
diff -w expected/test.txt results/test.txt  # Ignore whitespace
```

## Future Enhancements

- [ ] Add JSON test format for structured assertions
- [ ] Add timing assertions (max turns to solve)
- [ ] Add score assertions at checkpoints
- [ ] Add inventory state verification
- [ ] Add parallel test execution
- [ ] Add test coverage reporting
- [ ] Add CI/CD integration (GitHub Actions)
