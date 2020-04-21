#!/usr/bin/env bash

set -ex

export QUILT_PATCH_OPTS="--binary"

quilt push -af
quilt graph --all --lines=3 --reduce --edge-labels=files >patchgraph.dot
dot -Tpng patchgraph.dot >patchgraph.png
quilt pop -af
feh patchgraph.png
