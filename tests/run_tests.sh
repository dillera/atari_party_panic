#!/bin/bash
# Test Runner for Atari Party Panic
# Runs automated playthrough tests using frotz interpreter
#
# Usage: ./run_tests.sh [test_name]
#   If test_name is provided, runs only that test
#   Otherwise, runs all tests in tests/scripts/

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
GAME_FILE="../panic.z3"
SCRIPTS_DIR="scripts"
EXPECTED_DIR="expected"
RESULTS_DIR="results"

# Check if dfrotz is installed
if ! command -v dfrotz &> /dev/null; then
    echo -e "${RED}ERROR: dfrotz is not installed${NC}"
    echo "Install with: brew install frotz"
    exit 1
fi

# Check if game file exists
if [ ! -f "$GAME_FILE" ]; then
    echo -e "${RED}ERROR: Game file not found: $GAME_FILE${NC}"
    echo "Build the game first with: make"
    exit 1
fi

# Create results directory
mkdir -p "$RESULTS_DIR"

# Function to run a single test
run_test() {
    local test_name=$1
    local script_file="$SCRIPTS_DIR/${test_name}.txt"
    local expected_file="$EXPECTED_DIR/${test_name}.txt"
    local result_file="$RESULTS_DIR/${test_name}.txt"
    
    if [ ! -f "$script_file" ]; then
        echo -e "${RED}✗ Test script not found: $script_file${NC}"
        return 1
    fi
    
    echo -n "Running test: $test_name ... "
    
    # Run dfrotz (dumb frotz) for clean plain text output
    # -m: disable MORE prompts
    # -w: set screen width to avoid wrapping
    dfrotz -m -w 1000 "$GAME_FILE" < "$script_file" > "$result_file" 2>&1
    
    # If expected output exists, compare
    if [ -f "$expected_file" ]; then
        if diff -q "$expected_file" "$result_file" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ PASS${NC}"
            return 0
        else
            echo -e "${RED}✗ FAIL${NC}"
            echo -e "${YELLOW}  Expected output differs from actual output${NC}"
            echo "  Run: diff $expected_file $result_file"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ NO EXPECTED OUTPUT${NC}"
        echo "  Generated output at: $result_file"
        echo "  Review and copy to: $expected_file"
        return 2
    fi
}

# Function to run all tests
run_all_tests() {
    local total=0
    local passed=0
    local failed=0
    local no_expected=0
    
    echo "=========================================="
    echo "  Atari Party Panic - Test Suite"
    echo "=========================================="
    echo ""
    
    for script in "$SCRIPTS_DIR"/*.txt; do
        if [ -f "$script" ]; then
            test_name=$(basename "$script" .txt)
            total=$((total + 1))
            
            run_test "$test_name"
            result=$?
            
            if [ $result -eq 0 ]; then
                passed=$((passed + 1))
            elif [ $result -eq 1 ]; then
                failed=$((failed + 1))
            else
                no_expected=$((no_expected + 1))
            fi
        fi
    done
    
    echo ""
    echo "=========================================="
    echo "  Results: $total tests"
    echo "  ${GREEN}Passed: $passed${NC}"
    echo "  ${RED}Failed: $failed${NC}"
    echo "  ${YELLOW}No expected: $no_expected${NC}"
    echo "=========================================="
    
    if [ $failed -gt 0 ]; then
        exit 1
    fi
}

# Main execution
cd "$(dirname "$0")"

if [ $# -eq 0 ]; then
    # No arguments - run all tests
    run_all_tests
else
    # Run specific test
    run_test "$1"
fi
