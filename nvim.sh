#!/bin/sh

docker run --rm -it -v $(pwd):/repo cmake/base /launch_nvim.sh
