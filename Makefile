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
	@CURRENT_SIZE=`stat -f %z $(NAME).atr 2>/dev/null || stat -c %s $(NAME).atr 2>/dev/null`; \
	PADDING_SIZE=$$(($(DISK_SIZE)-$$CURRENT_SIZE)); \
	if [ $$CURRENT_SIZE -gt 0 ]; then \
		dd if=/dev/zero bs=1 count=$$PADDING_SIZE >> $(NAME).atr 2>/dev/null; \
		echo "Created $(NAME).atr with size: $$CURRENT_SIZE, padded to $(DISK_SIZE) bytes"; \
	else \
		echo "Error: Could not determine file size"; \
		exit 1; \
	fi



# Deploy to server
deploy: build
	scp $(NAME).atr actual:_services/tnfs/server_root/ATARI/TESTING/panic.atr

# Clean build artifacts
clean:
	rm -f $(NAME).z3 $(NAME).atr

.PHONY: clean deploy build