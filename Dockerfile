FROM gcc:13

# Install build tools
RUN apt-get update && apt-get install -y python3 python3-pip ninja-build clang-format clang-tidy gdb graphviz git curl zsh \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --break-system-packages meson gcovr

RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/bin

# Install latest doxygen
RUN wget --progress=bar:force:noscroll https://www.doxygen.nl/files/doxygen-1.10.0.linux.bin.tar.gz && \
    tar -xzf doxygen-1.10.0.linux.bin.tar.gz && \
    cd doxygen-1.10.0 && \
    make install && \
    cd .. && \
    rm -r doxygen-1.10.0.linux.bin.tar.gz && \
    rm -r doxygen-1.10.0

# Add a user `dev` with UID/GID 1000
# Set zsh as the default shell for this user
RUN groupadd -g 1000 dev && \
    useradd -m -u 1000 -g dev -s /bin/zsh dev

# Change to non-root user
USER dev

# Set up zsh to not suck
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -a 'bindkey "^[l" autosuggest-accept'

# Set the default shell for the container (optional, since it's already the default for the user)
# This is more about setting the shell when you exec into the container rather than changing the user's shell
SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["/bin/zsh"]
