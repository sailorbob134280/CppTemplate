# Default build prefix and type
BUILD_PREFIX := "./build"
BUILD_TYPE := "release"
set positional-arguments

# List all available targets
default:
  just --list

# Build and run the development environment
dev:
  docker build -t dev-container -f Dockerfile .
  # Note: running with the volumes mounted in the same directory allows clangd to work
  docker run -it --rm -v $(pwd):$(pwd) dev-container -c "cd $(pwd) && /bin/zsh"

# Bootstrap the project when cloning for the first time by installing git hooks and others
bootstrap:
  pre-commit install --hook-type commit-msg --hook-type pre-push

# Recipe to configure the build environment
configure:
  @echo "\nBUILD_PREFIX: {{BUILD_PREFIX}}\n\n"
  meson setup --buildtype={{BUILD_TYPE}} {{BUILD_PREFIX}}

# Build a target, or default if none is specified
build target="": configure
  ninja -C {{BUILD_PREFIX}} {{target}}

# Test recipe
test: build
  ninja -C {{BUILD_PREFIX}} test

# Coverage recipe
coverage: test
  ninja -C {{BUILD_PREFIX}} coverage

# Debug buildoutdated
debug: 
  meson configure {{BUILD_PREFIX}} --buildtype=debug
  ninja -C {{BUILD_PREFIX}}

# Release build
release: 
  meson configure {{BUILD_PREFIX}} --buildtype=release
  ninja -C {{BUILD_PREFIX}}

# Sanitize build
sanitize: 
  meson configure {{BUILD_PREFIX}} -Db_sanitize=address
  ninja -C {{BUILD_PREFIX}}
  ninja -C {{BUILD_PREFIX}} test

# Static analysis
check:
  ninja -C {{BUILD_PREFIX}} clang-tidy

# Run the autoformatter
format:
  ninja -C {{BUILD_PREFIX}} clang-format

# Build the documentation
docs:
  ninja -C {{BUILD_PREFIX}} docs/html

# Clean the build directory
clean:
  ninja -C {{BUILD_PREFIX}} clean

# Obliterate the build directory
spotless:
  rm -r {{BUILD_PREFIX}}
  meson subprojects purge --confirm
