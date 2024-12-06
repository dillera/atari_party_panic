# Makefile for Atari 8bit SingleDensity Puny Game
# dillera @2024 v1.0
# Modified from Puny BuildTools, (c) 2024 Stefan Vogt
# Simple and dirty make a bootable Atari Disk (ATR)
#_____________________________________________________

# Compiler settings
INFORM = inform
INFORM_FLAGS = -v3 +lib -Cu

# Source and build settings
NAME = panic
A8BIN = ./a8.bin
DISK_SIZE = 133136

# Build the game
$(NAME).z3: $(NAME).inf
	$(INFORM) $(INFORM_FLAGS) $< $@

# Build Atari disk image
build: $(NAME).z3
	cat $(A8BIN) $(NAME).z3 > $(NAME).atr 2>/dev/null
	SIZE=$$(ls -l $(NAME).atr | cut -d' ' -f5); \
	head --bytes $$(($(DISK_SIZE)-$$SIZE)) /dev/zero >> $(NAME).atr
	@echo "Disk image located in $(NAME).atr"

# Deploy to server
deploy: build
	scp $(NAME).atr actual:_services/tnfs/server_root/ATARI/TESTING/panic.atr

# Clean build artifacts
clean:
	rm -f $(NAME).z3 $(NAME).atr

.PHONY: clean deploy build