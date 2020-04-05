#!/usr/bin/env bash

set -ex

PBO="$1" ; shift 1

SRCDIR="${SRCDIR-src}"
# https://github.com/KoffeinFlummi/armake
ARMAKE="${ARMAKE-armake}"

export QUILT_PATCH_OPTS="--binary"
quilt pop -af || true

rm -rfv src/*

"$ARMAKE" unpack -f "${PBO}" "${SRCDIR}"

rm -f src/\$PBOPREFIX\$
