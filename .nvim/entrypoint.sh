#!/bin/sh

set -e

umask 000
cd /work

nvim +NvimTreeOpen +ToggleTerm Terminal
