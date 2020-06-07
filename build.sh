#!/usr/bin/env bash

set -ex

SRCDIR="${SRCDIR-src}"
# https://github.com/KoffeinFlummi/armake2
ARMAKE2="${ARMAKE2-armake2}"

export QUILT_PATCH_OPTS="--binary"
quilt push -a

VER_UPSTREAM="${VER_UPSTREAM-$(grep -Po '(?<=upstreamVersion = ")[^"]+' src/description.ext)}"
VER_FORK="${VER_FORK-$(grep -Po '(?<=downstreamVersion = ")[^"]+' src/description.ext)}"

VER_UPSTREAM="$(echo "$VER_UPSTREAM" | sed 's/\./_/g')"
VER_FORK="$(echo "$VER_FORK" | sed 's/\./_/g')"

PBO="${PBO-A3 - Antistasi Altis ${VER_UPSTREAM} Greenfork ${VER_FORK}.Altis.pbo}"
"$ARMAKE2" build "$SRCDIR" "$PBO"

quilt pop -a
