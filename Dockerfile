FROM gcc:12

# Install build tools
RUN apt-get update && apt-get install -y python3 ninja-build python3-pip gdb graphviz git
RUN pip install meson gcovr
# The version of doxy in the Debian repos is too old to support concepts, so we grab the latest release and manually install
RUN wget --progress=bar:force:noscroll https://www.doxygen.nl/files/doxygen-1.9.5.linux.bin.tar.gz && \
    tar -xzf doxygen-1.9.5.linux.bin.tar.gz && \
    cd doxygen-1.9.5 && \
    make install && \
    cd .. && \
    rm -r doxygen-1.9.5.linux.bin.tar.gz && \
    rm -r doxygen-1.9.5

WORKDIR /usr/src/app
