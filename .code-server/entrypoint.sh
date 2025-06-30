#!/bin/sh

set -e

umask 000
cd /work

mkdir -p /work/.code-server
code-server /work 1> /work/.code-server/code-server.log
