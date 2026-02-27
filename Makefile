CFLAGS ?= -O3 -flto

# Detect platform
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Default target
ifeq ($(UNAME_S)_$(UNAME_M),Darwin_arm64)
  # Apple Silicon - build native ARM64 only
  all: rnc_arm64
  TARGETS = rnc_arm64
  PRIMARY = rnc_arm64
else
  # Intel Mac, Linux, and other platforms - build both
  all: rnc64 rnc32
  TARGETS = rnc64 rnc32
  PRIMARY = rnc64
endif

.PHONY: all

# Apple Silicon ARM64 build
rnc_arm64: main.c
	$(CC) $(CFLAGS) -target arm64-apple-macos11 $< -o $@

# 32-bit build (only on supported platforms)
rnc32: CFLAGS += -m32
rnc32: main.c
	$(CC) $(CFLAGS) $< -o $@

# 64-bit build
rnc64: main.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f $(TARGETS) rnc64 rnc_arm64 rnc32
.PHONY: clean
