# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Neovim
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get update && \
    add-apt-repository -y ppa:neovim-ppa/unstable && \
    apt-get install -y --no-install-recommends \
                       git \
                       curl \
                       gdb \
                       neovim \
                       vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install OpenDebugAD7
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y unzip && \
    mkdir -p /usr/OpenDebugAD7 && \
    cd /usr/OpenDebugAD7 && \
    curl -L --output OpenDebugAD7.vsix \
    https://github.com/microsoft/vscode-cpptools/releases/download/v1.26.3/cpptools-linux-x64.vsix && \
    unzip OpenDebugAD7.vsix && \
    rm OpenDebugAD7.vsix && \
    chmod +x ./extension/debugAdapters/bin/OpenDebugAD7 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install code-server
ENV CODE_SERVER_VERSION=4.100.3
RUN curl -fsSL \
        https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION}_amd64.deb \
        -o code-server.deb && \
    apt-get update && \
    apt-get install -y ./code-server.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm code-server.deb

# Configure Neovim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY .nvim/nvim /root/.config/nvim
RUN nvim --headless +PlugInstall +qall

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
