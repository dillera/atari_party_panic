# Deep Debug Results - Cheap Scenery Investigation

## Root Cause Identified

**The CheapScenery object is NOT being added to scope in the full game.**

### Evidence

1. **Minimal Test (WORKS)**:
   ```
   [DEBUG] CheapScenery.found_in called, location=Test Room
   [DEBUG parse_name] ENTRY - location=Test Room (9)
   You see a test thing.  ✅
   ```

2. **Full Game (FAILS)**:
   ```
   [DEBUG] TrainStation provides cheap_scenery? 1  ✅ Property exists
   [DEBUG] location is now: Lobby (12)  ✅ Location set correctly
   (NO debug output from found_in or parse_name)  ❌ Never called!
   Warning: @get_prop_addr called with object 0
   You can't see any such thing.  ❌
   ```

### What This Means

The parser is never checking if CheapScenery should be in scope. The `found_in` routine, which should return true when `location provides cheap_scenery`, is never being called.

This suggests a fundamental difference in how objects are registered/initialized between the minimal test and the full game.

## Attempted Fixes (All Failed)

1. ❌ Include order: Tried both before AND after puny.h
2. ❌ Removed SceneryReply routine
3. ❌ Simplified cheap_scenery syntax
4. ❌ Added manual floating_objects entry
5. ❌ Verified property declaration as `individual`

## Remaining Hypotheses

1. **Module loading order**: The modular structure (separate room files) may affect object initialization
2. **PunyInform internals**: Some configuration constant or library setting might affect scope calculation
3. **Object tree timing**: TrainStation defined in separate file might not be "ready" when CheapScenery initializes
4. **Missing initialization step**: Some setup that minimal test does implicitly that we're missing

## Next Steps Options

1. **Inline room definition**: Try moving TrainStation definition directly into panic.inf (not modular)
2. **Check PunyInform constants**: Review all OPTIONAL_*  constants in config
3. **Community help**: Post to PunyInform forums/GitHub with minimal reproduction case
4. **Alternative implementation**: Use traditional Inform scenery objects instead

## Files Modified During Debug

- `lib/ext_cheap_scenery.h` - Added debug prints (needs restoring)
- `src/init.inf` - Added debug prints
- `panic.inf` - Tried various include orders
- `src/config.inf` -  Enabled DEBUG
