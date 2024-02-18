FROM gcc:13

# Install build tools
RUN apt-get update && apt-get install -y python3 python3-pip ninja-build clang-format clang-tidy gdb openjdk-17-jdk-headless graphviz git curl zsh \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --break-system-packages meson gcovr

RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/bin

# Install mold from tarball, as the version in the package manager is very old
RUN wget -O mold.tar.gz https://github.com/rui314/mold/releases/download/v2.4.0/mold-2.4.0-x86_64-linux.tar.gz && \
    tar -xzf mold.tar.gz && \
    cp -r mold-2.4.0-x86_64-linux/* /usr/local/ && \
    rm -r mold-2.4.0-x86_64-linux && \
    rm mold.tar.gz

# Set mold as the default linker
ENV CC_LD=mold
ENV CXX_LD=mold

# Install plantuml
RUN wget --progress=bar:force:noscroll https://github.com/plantuml/plantuml/releases/download/v1.2024.3/plantuml-mit-1.2024.3.jar -O /usr/local/bin/plantuml.jar

# Install node for actions
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && apt-get install -y nodejs

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
