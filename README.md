# ${REPO_NAME_PASCAL}

${REPO_DESCRIPTION}

## Build Instructions

The provided Docker image includes all necessary dependencies to build and debug C/C++ applications. While the main build system is Meson, a Justfile is provided for convenience. With dependencies installed, or inside the Docker container, run the following:

```
Available recipes:
    bootstrap       # Bootstrap the project when cloning for the first time by installing git hooks
    build target="" # Build a target, or default if none is specified
    check           # Static analysis
    clean           # Clean the build directory
    configure       # Recipe to configure the build environment
    coverage        # Coverage recipe
    debug           # Debug build
    default         # List all available targets
    dev             # Build and run the development environment
    docs            # Build the documentation
    format          # Run the autoformatter
    release         # Release build
    sanitize        # Run tests with address sanitizer
    spotless        # Obliterate the build directory
    test            # Run the unit tests
```
