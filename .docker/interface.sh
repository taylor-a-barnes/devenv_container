#!/bin/sh

image="${1:-taylorabarnes/devenv:latest}"
port="${2:-56610}"

echo "Which of the following would you like to open?"
echo "1) Neovim"
echo "2) VS Code"
echo "3) Terminal (default)"
echo ""
echo "Note: If you select VS Code, this container will launch a VS Code server."
echo "      You can then access the server by point a web browser to http://localhost:${port}"
echo ""
read -p "Enter your choice [1-3]: " choice
echo ""

# Set default if input is empty
choice=${choice:-3}

case $choice in
  1)
    echo "Opening Neovim"
    echo ""
    docker run --rm -it -v $(pwd):/repo ${image} bash /.nvim/entrypoint.sh
    ;;
  2)
    # Check if any container is already using the port
    CID=$(docker ps --filter "publish=${port}" -q)
    if [ -n "$CID" ]; then
      echo "Cleaning up old container on port ${port}..."
      docker stop "$CID"
      echo ""
    fi

    # Launch the container
    echo "Launching VS Code through code-server."
    echo "To use it, open a web browser to http://localhost:${port}"
    echo ""
    docker run --rm -it -v $(pwd):/repo -p 127.0.0.1:${port}:8080 ${image} bash /.code-server/entrypoint.sh
    ;;
  3)
    echo "Entering an interactive terminal session"
    echo ""
    docker run --rm -it -v $(pwd):/repo ${image}
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac
