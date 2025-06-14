#!/bin/sh

set -e

umask 000
cd /repo

echo "Which of the following would you like to open?"
echo "1) Neovim"
echo "2) VS Code"
echo "3) Terminal (default)"
echo ""
echo "Note: If you select VS Code, this container will launch a VS Code server."
echo "      You can then access the server by point a web browser to http://localhost:56610"
echo ""
read -p "Enter your choice [1-3]: " choice
echo ""

# Set default if input is empty
choice=${choice:-3}

case $choice in
  1)
    echo "Opening Neovim"
    echo ""
    nvim +NvimTreeOpen +ToggleTerm Terminal
    ;;
  2)
    echo "Launching VS Code through code-server."
    echo "To use it, open a web browser to http://localhost:56610"
    echo ""
    code-server /repo 1> /repo/.code-server/code-server.log
    ;;
  3)
    echo "Entering an interactive terminal session"
    echo ""
    bash "$@"
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac