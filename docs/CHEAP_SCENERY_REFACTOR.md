# Cheap Scenery Refactoring - Complete Rebuild

**Date:** November 23, 2025  
**Branch:** `cheap`  
**Status:** ✅ Complete and Working

---

## Overview

This document details the complete refactoring of `panic.inf` to properly integrate PunyInform's `cheap_scenery` extension. After extensive debugging, we discovered the issue was the **include order**, not the code itself.

## The Problem

The original modular architecture with separate files in `src/` was preventing `cheap_scenery` from working correctly. Symptoms included:
- Runtime errors when examining cheap scenery objects
- "Cheap_scenery error #3" messages
- Objects not being recognized by the parser

## Root Cause: Include Order

The critical issue was discovered by examining the working example in `library_of_horror.inf`. The correct include order is:

```inform
1. globals.h
2. SceneryReply function (BEFORE ext_cheap_scenery.h)
3. ext_cheap_scenery.h (BEFORE puny.h)
4. puny.h
5. Game code (state, objects, etc.)
```

**The Problem:** Our original code had:
```inform
globals.h → puny.h → ext_cheap_scenery.h  ❌
```

**The Solution:**
```inform
globals.h → ext_cheap_scenery.h → puny.h  ✅
```

## Solution: Monolithic Rebuild

Given the complexity of maintaining proper include order with modular files, we rebuilt `panic.inf` as a single cohesive file with all game content integrated directly.

### Architecture Decision

Following Eskil Steenberg's black box design principles, we opted for a **single-file approach** because:
1. **Clear boundaries:** All game logic in one place makes dependencies explicit
2. **Maintainability:** No hidden ordering issues from includes
3. **Simplicity:** Easier to understand the complete system at once
4. **Modularity through sections:** Clear comment headers separate concerns

## Changes Made

### 1. Include Order Fix

**New structure in `panic.inf`:**
```inform
!==============================================================================
! GLOBALS & CONFIGURATION
!==============================================================================
#Include "src/config.inf";

!==============================================================================
! PUNYINFORM LIBRARY & EXTENSIONS
!==============================================================================
Include "lib/globals.h";

!==============================================================================
! CHEAP SCENERY - Must be defined BEFORE puny.h
!==============================================================================
[ SceneryReply p_word1 p_word2 p_id_or_routine;
    default:
        p_word1 = p_word2 + p_id_or_routine;
        "Better just focus on what you need to do.";
];
Include "lib/ext_cheap_scenery.h";

!==============================================================================
! PUNY INFORM CORE
!==============================================================================
Include "lib/puny.h";

!==============================================================================
! GAME STATE & ROOMS
!==============================================================================
Include "src/state.inf";
Include "src/rooms/platform.inf";

!==============================================================================
! NARRATIVE FUNCTIONS
!==============================================================================
[LogbookEntries; ... ]
[DiaryEntries; ... ]

!==============================================================================
! ROOMS
!==============================================================================
[All rooms defined inline]

!==============================================================================
! INITIALIZATION
!==============================================================================
[Initialise; ... ]
```

### 2. Integrated Modules

All modular files were integrated directly into `panic.inf`:

#### Rooms Integrated:
- **TrainStation (Lobby)** - Main hub with cheap_scenery for ataris, windows
  - Contains: framedArticle, articlePlaque objects
- **TicketOffice** - Swap meet area with cheap_scenery for tables, timetables, poster
  - Contains: atariBox, atariDisk, pokeyChip, tools, drive objects
- **StorageArea** - Hidden trapdoor room with cheap_scenery for shelves, luggage
  - Contains: rug, trapdoor objects
- **BunkerRoom** - Secret facility with cheap_scenery for racks, equipment, table, fans
  - Contains: logbook, diary, securityModem, atari800, chipSlot objects

#### Narrative Functions:
- **LogbookEntries()** - Sequential reading system (5 entries)
- **DiaryEntries()** - Sequential reading system (5 entries)

### 3. Cheap Scenery Implementation

Each room now has fully functional cheap_scenery without creating full objects:

**Example - TrainStation:**
```inform
cheap_scenery
    'atari' 'ataris//p' "The tables are packed with Atari 800s, 65XE's, and even a few STs."
    'window' 'windows//p' "Tall Victorian windows line the walls.",
```

**Example - BunkerRoom:**
```inform
cheap_scenery
    'rack' 'racks//p' "Racks of vintage 1970s and 80s computing equipment."
    'equipment' 'electronics' "Vintage computing equipment from the 1970s and 80s."
    1 'table' "A heavy metal table supporting the Atari system."
    'fan' 'fans//p' "Cooling fans humming quietly in the background.",
```

### 4. Files Removed (No Longer Needed)

**Integrated into panic.inf (7 files):**
- `src/narrative/diary.inf`
- `src/narrative/logbook.inf`
- `src/objects/atari800.inf`
- `src/rooms/bunker.inf`
- `src/rooms/lobby.inf`
- `src/rooms/storage.inf`
- `src/rooms/ticket_office.inf`

**Never used (6 files):**
- `src/events.inf`
- `src/init.inf`
- `src/narrative/notebooks.inf`
- `src/objects/fixtures.inf`
- `src/objects/items.inf`
- `src/verbs.inf`

**Empty directories removed:**
- `src/narrative/`
- `src/objects/`

### 5. Final Source Structure

```
src/
├── config.inf          # Game constants and settings
├── state.inf           # Global game state variables
└── rooms/
    └── platform.inf    # Platform room (kept for future use)
```

## Technical Issues Resolved

### 1. Invalid Object Syntax
**Problem:** Objects had `has ;` which is invalid  
**Solution:** Removed empty `has` clauses, objects now properly terminated

### 2. Z3 Name Property Limit
**Problem:** `atari800` had 5 words in name property (Z3 limit is 4)  
**Solution:** Reduced to 4 words: `'atari' '800' 'computer' 'system'`

### 3. Global Variable Ordering
**Problem:** Narrative functions used globals before they were defined  
**Solution:** Moved narrative functions after `state.inf` include

### 4. Object Attributes
**Problem:** Key items had `static` attribute preventing pickup  
**Solution:** Removed `static` from pokeyChip, atariDisk, logbook, diary

## Testing Results

### Compilation
```
✅ Compiles cleanly with only expected warnings
✅ 4 warnings (unused helper functions in state.inf)
✅ No errors
```

### Cheap Scenery Tests
All rooms tested with various scenery objects:

**TrainStation:**
```
> x ataris
The tables are packed with Atari 800s, 65XE's, and even a few STs.

> x windows
Tall Victorian windows line the walls.
```

**TicketOffice:**
```
> x tables
Folding tables covered with Atari equipment and parts.

> x poster
The poster states: ALL SALES FINAL!
```

**BunkerRoom:**
```
> x racks
Racks of vintage 1970s and 80s computing equipment.

> x equipment
Vintage computing equipment from the 1970s and 80s.
```

### Game Flow Test
```
✅ Navigate between all rooms
✅ Find and take POKEY chip from TicketOffice
✅ Get tools from TicketOffice
✅ Move rug in StorageArea
✅ Descend to BunkerRoom
✅ Examine Atari 800 (shows error about missing chip)
✅ Read logbook entries (sequential reading works)
✅ Read diary entries (sequential reading works)
✅ Cheap scenery responds correctly in all locations
```

## Lessons Learned

### 1. Include Order Matters
The order of library includes in PunyInform is **critical**. Extension files that modify core behavior must be included before `puny.h`.

### 2. Working Examples Are Gold
`library_of_horror.inf` provided the key insight. When debugging library extensions, always check for working examples in the distribution.

### 3. Sometimes Monolithic Is Better
While modular code is generally preferred, for IF games with complex library dependencies, a single well-organized file can be clearer and more maintainable.

### 4. Black Box Design Principles
Even in a single file, we maintained clear section boundaries:
- **Configuration** (external file)
- **State** (external file)
- **Narrative Functions** (clear section)
- **Rooms** (clear section with comments)
- **Initialization** (clear section)

## Future Improvements

1. **Platform Room:** Currently included but not connected - decide whether to integrate or remove
2. **Event System:** Consider if `events.inf` functionality is needed
3. **Additional Rooms:** Easy to add new rooms with cheap_scenery following established patterns
4. **Optimization:** Could extract SceneryReply into `src/` if it grows more complex

## References

- **PunyInform Quick Reference v6.1:** `PunyInformQuickRef_v6.1.md`
- **Working Example:** `library_of_horror.inf`
- **Extension Documentation:** `lib/ext_cheap_scenery.h` (lines 1-152)

## Key Insight

> **The problem was never the modular architecture itself, but the difficulty of maintaining correct include order across multiple files. By consolidating into a single file with clear section markers, we made dependencies explicit and eliminated ordering issues entirely.**

---

## Build Instructions

```bash
# Compile the game
make panic.z3

# Or manually:
/usr/local/bin/inform -v3 +lib -Cu panic.inf panic.z3

# Build Atari disk image
make build

# Clean build artifacts
make clean
```

## Game Size

- **panic.inf:** ~450 lines (well-organized, easy to navigate)
- **panic.z3:** Compiles within Z3 limits
- All cheap_scenery working perfectly without object overhead

---

**Status:** This refactoring is complete and working. The game now uses cheap_scenery correctly throughout, maintaining both functionality and readability.
