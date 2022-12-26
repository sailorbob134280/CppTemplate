###############################################################################
# Simple Makefile to prevent the need to interact with Meson directly.
#
# While Meson and Ninja are many things, intuitive is not one of them when it
# comes to the command line. This is easily rectified with a simple make file
# to hide the details and present a simple and familiar interface. This will
# allow Meson and Ninja to do their thing with a few options:
#
# 		- BUILD_PREFIX = The build directory, defaults to ./build
#		- BUILD_TYPE = release or debug
#
# All other build targets get passed straight to Ninja
###############################################################################

# Default to a less-verbose build.  If you want all the gory compiler output,
# run "make VERBOSE=1"
$(VERBOSE).SILENT:

# Figure out where to build the software.
#   Use BUILD_PREFIX if it was passed in.
#   If not, search up to four parent directories for a 'build' directory.
#   Otherwise, use ./build.
ifeq "$(BUILD_PREFIX)" ""
BUILD_PREFIX:=$(shell for pfx in ./ .. ../.. ../../.. ../../../..; do d=`pwd`/$$pfx/build;\
               if [ -d $$d ]; then echo $$d; exit 0; fi; done; echo `pwd`/build)
endif

# create the build directory if needed, and normalize its path name
BUILD_PREFIX:=$(shell mkdir -p $(BUILD_PREFIX) && cd $(BUILD_PREFIX) && echo `pwd`)

# Default to a release build.  If you want to enable debugging flags, run
# "make BUILD_TYPE=debug"
ifeq "$(BUILD_TYPE)" ""
BUILD_TYPE="release"
endif

all: $(BUILD_PREFIX)/build.ninja
	ninja -C $(BUILD_PREFIX)

$(BUILD_PREFIX)/build.ninja:
	$(MAKE) configure

.PHONY: configure
configure:
	@echo "\nBUILD_PREFIX: $(BUILD_PREFIX)\n\n"

	@meson setup --buildtype=$(BUILD_TYPE) $(BUILD_PREFIX)

# This needs to be separate for some reason
test: $(BUILD_PREFIX)/build.ninja
	ninja -C $(BUILD_PREFIX) test

coverage: test
	ninja -C $(BUILD_PREFIX) coverage

debug: $(BUILD_PREFIX)/build.ninja
	meson configure $(BUILD_PREFIX) --buildtype=debug
	ninja -C $(BUILD_PREFIX)

release: $(BUILD_PREFIX)/build.ninja
	meson configure $(BUILD_PREFIX) --buildtype=release
	ninja -C $(BUILD_PREFIX)

sanitize: $(BUILD_PREFIX)/build.ninja
	meson configure $(BUILD_PREFIX) -Db_sanitize=address
	ninja -C $(BUILD_PREFIX)

spotless:
	rm -r $(BUILD_PREFIX)
	meson subprojects purge --confirm

# other (custom) targets are passed through to the Meson genarated Ninja file
% ::
	ninja -C $(BUILD_PREFIX) $@