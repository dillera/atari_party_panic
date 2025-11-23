#!/usr/bin/env python3
"""
Clean frotz output for testing
Removes ANSI codes, normalizes whitespace, extracts meaningful game text
"""
import sys
import re

def clean_frotz_output(text):
    """Clean frotz output for comparison"""
    
    # Remove all ANSI escape sequences
    ansi_escape = re.compile(r'\x1b[@-_][0-?]*[ -/]*[@-~]')
    text = ansi_escape.sub('', text)
    
    # Remove carriage returns
    text = text.replace('\r', '')
    
    # Split on common prompt marker
    text = text.replace('> ', '\n> ')
    
    # Split long lines at sentence boundaries
    text = re.sub(r'([.!?])\s+([A-Z])', r'\1\n\2', text)
    
    # Clean up multiple spaces
    text = re.sub(r' +', ' ', text)
    
    # Split on common game markers
    text = text.replace('You can see', '\nYou can see')
    text = text.replace('Suddenly,', '\nSudddenly,')
    
    # Extract meaningful lines
    lines = []
    skip_patterns = [
        r'^\s*Score:',
        r'^\s*Moves:',
        r'^\s*\d+\s*$',  # Just numbers (turn counter)
    ]
    
    for line in text.split('\n'):
        line = line.strip()
        if not line:
            continue
        
        # Skip lines matching patterns
        skip = False
        for pattern in skip_patterns:
            if re.match(pattern, line):
                skip = True
                break
        
        if not skip:
            lines.append(line)
    
    return '\n'.join(lines)

if __name__ == '__main__':
    text = sys.stdin.read()
    print(clean_frotz_output(text))
