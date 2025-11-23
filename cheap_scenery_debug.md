# Cheap Scenery Debugging Report

## Issue
Cheap scenery extension not working despite extensive fixes.

## What I've Tried

1. **✅ Minimal Test Case** - Created `test_cheap.inf` that WORKS PERFECTLY
   - Proves the extension itself functions correctly
   
2. **✅ Include Order Fix** - Moved `ext_cheap_scenery.h` before `puny.h`
   - Matches library_of_horror.inf structure
   - Added SceneryReply routine as in working example
   
3. **✅ Syntax Simplification** - Removed complex routines from cheap_scenery
   - Used only simple string reactions
   - Removed ID prefixes
   - Removed conditional logic
   
4. **❌ Still Failing** - Error persists: `@get_prop_addr called with object 0`

## The Error

`Warning: @get_prop_addr called with object 0 (PC = 5606)`

This indicates the extension is trying to access a property on object  0 (null/invalid object), suggesting the `location` global may not be set correctly when cheap_scenery's `found_in` routine executes.

## Hypothesis

The issue may be related to when/how the location global is initialized vs when the cheap_scenery extension tries to access it. In the minimal test, initialization is trivial. In the full game, there's more complexity.

## Next Steps to Try

1. Add explicit debug prints in CheapScenery found_in to trace execution
2. Verify location is set before CheapScenery checks it
3. Check if there's a scope/timing issue with object initialization
4. Try moving TrainStation definition earlier in compilation order
5. Check if other properties/attributes on TrainStation conflict
