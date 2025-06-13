#!/bin/sh

docker run --rm -it -v $(pwd):/repo taylorabarnes/devenv /launch_nvim.sh
