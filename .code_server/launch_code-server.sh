#!/bin/sh

set -e

umask 000
cd /repo
code-server /repo
