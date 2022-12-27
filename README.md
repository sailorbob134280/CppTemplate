# ${REPO_NAME_PASCAL}

![CI](https://concourse.shrukanslab.xyz/api/v1/teams/sl-devs/pipelines/cpp-template/badge)

${REPO_DESCRIPTION}

## Build Instructions
The provided Docker image includes all necessary dependencies to build and debug
C/C++ applications. While the main build system is Meson, a Makefile is provided
for convenience. With dependencies installed, or inside the Docker container, run
the following:

- `make` to build the application
- `make test` to run all configured tests
- `make coverage` to run tests and generate coverage reports
- `make debug` to compile with debug flags
- `make release` to compile with release optimization (default)
- `make sanitize` to compile with address sanitizer
- `make scan-build` to run LLVM scan-build, if installed (not by default in the docker image)
- `make docs/html` to build the HTML Doxygen documentation
- `make clang-format` to run the autoformatter
- `make clean` to delete artifacts from the build directory
- `make spotless` to delete the build directory altogether and purge subprojects

All other targets are passed directly to the Ninja backend.