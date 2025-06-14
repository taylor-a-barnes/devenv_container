#!/bin/sh

set -e

umask 000
cd /repo

code-server /repo 1> /repo/.code-server/code-server.log
