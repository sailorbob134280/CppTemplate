# Set default values for variables. Justfile doesn't support dynamic defaulting in
# the same way Make does, so we have to handle it within the command executions.

# Default build prefix and type
BUILD_PREFIX := "./build"
BUILD_TYPE := "release"
set positional-arguments

# Set up the actual BUILD_PREFIX based on the presence of the directory
#BUILD_PREFIX := `mkdir -p {{BUILD_PREFIX}} && cd {{BUILD_PREFIX}} && pwd`

default: build

dev:
  docker build -t dev-container -f Dockerfile .
  docker run -it --rm -v $(pwd):$(pwd) dev-container -c "cd $(pwd) && /bin/zsh"

# Recipe to configure the build environment
configure:
  @echo "\nBUILD_PREFIX: {{BUILD_PREFIX}}\n\n"
  meson setup --buildtype={{BUILD_TYPE}} {{BUILD_PREFIX}}

# Default build target
build target="": configure
  ninja -C {{BUILD_PREFIX}} {{target}}

# Test recipe
test: build
  ninja -C {{BUILD_PREFIX}} test

# Coverage recipe
coverage: test
  ninja -C {{BUILD_PREFIX}} coverage

# Debug build
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
