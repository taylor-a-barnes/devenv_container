# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get update && \
    add-apt-repository -y ppa:neovim-ppa/unstable && \
    apt-get install -y \
                       cmake \
                       curl \
                       g++ \
                       git \
                       neovim \
                       vim && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/*

# Copy the entrypoint file into the Docker image
COPY entrypoint.sh /entrypoint.sh
COPY .nvim/launch_nvim.sh /launch_nvim.sh

# Configure Neovim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN mkdir -p ~/.config/nvim
COPY .nvim/init.lua /root/.config/nvim/init.lua
RUN nvim --headless +PlugInstall +qall

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the command
CMD ["/entrypoint.sh"]
