# Atari Party Panic (2025 Edition)

**Release 2 (v1.3) - November 2025**

*System Maintenance Log: Facility SENTINEL-QT. Status: LOCKDOWN.*

A PunyInform interactive fiction game for the Atari 8-bit computers (and other Z-machine interpreters).

## 🎮 Gameplay Updates (2025)

The 2025 edition (Release 2) introduces significant enhancements:
- **Extended Ending**: A new narrative conclusion involving a mysterious bunker corridor.
- **New Items**: Discover the Atari 810 disk drive and ATASCII reference card.
- **Scoring System**: Points are now awarded for finding key items (POKEY chip, Tools, etc.).
- **Bug Fixes**: Resolved issues with platform lockdown, inventory management, and object descriptions.
- **Engine Update**: Built with the latest PunyInform v6.1.1 and Inform 6.44.

## 📂 Project Structure

- `src/` - Source code modules (rooms, logic, config)
- `tests/` - Automated test suite and test sources
- `docs/` - Design documentation and manuals
- `lib/` - PunyInform library files
- `panic.inf` - Main game entry point
- `Makefile` - Build automation

## ��️ Building the Game

### Requirements
- **Inform 6 Compiler** (v6.30 or later)
- **Make**

### Build Commands

| Command | Description | Output |
|---------|-------------|--------|
| `make` | Compiles the Z-machine story file | `panic.z3` |
| `make build` | Creates a bootable Atari disk image | `panic.atr` |
| `make deploy` | Builds and uploads to TNFS server | (Remote upload) |
| `make clean` | Removes build artifacts | |

The `panic.atr` file is a bootable Single Density (90k/130k) disk image ready for Atari emulators (Altirra, Atari800) or real hardware via FujiNet/SIO2SD.

## 🧪 Testing

The project includes a comprehensive automated test suite in the `tests/` directory.

### Running Tests

To run the full regression suite:
```bash
cd tests
./test_endgame.sh        # Verifies full walkthrough and victory
./test_scoring.sh        # Checks scoring logic
./test_minimal.sh        # Tests core inventory mechanics
./test_platform_rescue.sh # Tests platform rescue event
```

Each script compiles the game (if needed) and runs `dfrotz` with input scripts, verifying the output against expected regex patterns.

### Manual Testing
You can play the compiled game directly in the terminal:
```bash
dfrotz panic.z3
```

## 📜 Credits

**Author**: Andrew Diller
**System Architecture**: PunyInform v6.1.1 by Johan Berntsson and Fredrik Ramsberg
**Compiler**: Inform 6.44
**Release**: 2 / Serial 251126

*Dedicated to the 8-bit era.*
