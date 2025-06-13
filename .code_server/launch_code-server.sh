#!/bin/sh

set -e

umask 000
cd /repo
code-server --bind-addr 0.0.0.0:56610 --cert false --auth none
