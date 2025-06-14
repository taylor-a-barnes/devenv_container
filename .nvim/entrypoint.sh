#!/bin/sh

set -e

umask 000
cd /repo

nvim +NvimTreeOpen +ToggleTerm Terminal
