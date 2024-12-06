# atari_party_panic

SYSTEM MAINTENANCE LOG
Facility: Quakertown Station Underground Command Center
System: SENTINEL-QT (Atari 800 Terminal Interface)

1991-08-15
Final system diagnostic before facility decommission. All security protocols still active. Reminder: System will maintain lockdown protocols even after power loss due to custom backup circuits.


Don't panic, you know this.


## Quick Build - on a Mac, for Atari 170k disk
```
$ make
$ make build
$ made deploy
$ make clean
```

 - make    - invokes inform, outputs a .z3
 - build   - invokes some bash and outputs an .atr bootable disk image
 - deploy  - scp's the disk image to my tnfs server for loading
 - clean   - removes the .z3 and .art files from the filesystem

 Adjust as necessary (the story name, tnfs server target) in the Makefile and save.
 

## Manual Building from Source


### OSX Setup

Building with Puny requires Inform, you can install it via brew:
```
brew install inform
```

Playing the game can be done with frotz. Download some Atari fonts and set the screen to be 40x24...
```
$ brew install frotz
```

### Build Game:
For now, we are just interested in a z3 version of the game so that it can fit on a real physical Atari 90k disk.

```
$ inform -v3 +lib  -Cu panic.inf artifacts/panic.z3
```

The built files should always be placed in the artifacts directory so that the buils scrips can find them when creating the disk images.


## Entomb

```
cd build

```

run the build scripts, atari.sh and apple2.sh.
Both of these are pulled from https://github.com/ByteProject/Puny-BuildTools
which is a great project that builds across a wide range of 8bit systems.

For my project I _only_ want Atari8 and Apple2 .z3 images to convert to real physical floppies....

```
$ ./atari.sh

```
This expects to find a panic.z3 file in the build directory and it will create an Atari image.

```
$ ./apple2.sh
```

This is not tested by myself yet.


### Move the Images to a TNFS server

```
scp ../artifacts/panic_atari8bit.atr actual:_services/tnfs/server_root/ATARI/TESTING/panic.atr

```

Now using a real Atari, with a 1050 disk drive setup as D3: and a FujiNet on the same SIO chain, boot the FujiNet and run the 810 copy program. Mount the panic.atr as the 2nd disk drive (D2:). Boot FN using OPTION.

I'll put screen shots in here, but run the copier, source is D2: and destination is D3:


## Testing

Once this is done you have to test by disconnecting the FN (use the switch on the side to turn it off) and set the 1050 as D1: - boot the disk and the game should load.



