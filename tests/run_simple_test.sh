#!/bin/bash
# Simple test runner that generates clean transcripts
# Uses dfrotz (dumb frotz) for plain text output

set -e

GAME_FILE="../panic.z3"
SCRIPT_FILE="$1"

if [ -z "$SCRIPT_FILE" ]; then
    echo "Usage: $0 <script_file>"
    exit 1
fi

if ! command -v dfrotz &> /dev/null; then
    echo "dfrotz not found. Install with: brew install frotz"
    exit 1
fi

# dfrotz produces clean plain text output
dfrotz -m -w 1000 "$GAME_FILE" < "$SCRIPT_FILE"
