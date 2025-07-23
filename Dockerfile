# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Neovim
RUN apt clean && \
    apt update && \
    apt install -y software-properties-common && \
    apt update && \
    add-apt-repository -y ppa:neovim-ppa/unstable && \
    apt install -y --no-install-recommends \
                       clang \
                       curl \
                       gdb \
                       git \
                       neovim \
                       npm \
                       vim && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Install Cargo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    . "$HOME/.cargo/env" && \
    rustup install nightly && \
    rustup default nightly

# Install OpenDebugAD7
RUN apt clean && \
    apt update && \
    apt install -y unzip && \
    mkdir -p /usr/OpenDebugAD7 && \
    cd /usr/OpenDebugAD7 && \
    curl -L --output OpenDebugAD7.vsix \
    https://github.com/microsoft/vscode-cpptools/releases/download/v1.26.3/cpptools-linux-x64.vsix && \
    unzip OpenDebugAD7.vsix && \
    rm OpenDebugAD7.vsix && \
    chmod +x ./extension/debugAdapters/bin/OpenDebugAD7 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Install code-server
ENV CODE_SERVER_VERSION=4.100.3
RUN curl -fsSL \
        https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION}_amd64.deb \
        -o code-server.deb && \
    apt update && \
    apt install -y ./code-server.deb && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm code-server.deb

# Configure Neovim
#RUN . "$HOME/.cargo/env" && \
#    cargo install neocmakelsp
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY .nvim/nvim /root/.config/nvim
RUN nvim --headless +PlugInstall +qall
RUN nvim --headless "+MasonInstall lua-language-server pyright clangd neocmakelsp" +q

# Install Tree Sitter Language Parsers
RUN apt clean && \
    apt update && \
    apt install -y \
                       gcc && \
    nvim --headless +"TSInstallSync bash c cmake cpp cuda lua python rust vim vimdoc query markdown markdown_inline" +qall && \
    apt remove gcc -y && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Configure code-server
EXPOSE 8080
RUN mkdir -p ~/.config/code-server
COPY .code-server/config.yaml /root/.config/code-server/config.yaml
RUN mkdir -p /root/.local/share/code-server/User
COPY .code-server/settings.json /root/.local/share/code-server/User/settings.json

COPY .docker/interface.ps1 /interface.ps1
COPY .docker/interface.sh /interface.sh

# Copy the entrypoint files into the Docker image
COPY .term/entrypoint.sh /.term/entrypoint.sh
RUN chmod +x /.term/entrypoint.sh
RUN mkdir -p /.nvim
COPY .nvim/entrypoint.sh /.nvim/entrypoint.sh
RUN chmod +x /.nvim/entrypoint.sh
RUN mkdir -p /.code-server
COPY .code-server/entrypoint.sh /.code-server/entrypoint.sh
RUN chmod +x /.code-server/entrypoint.sh

# Set the default command
CMD ["/.term/entrypoint.sh"]
