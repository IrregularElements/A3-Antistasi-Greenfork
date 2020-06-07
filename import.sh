#!/usr/bin/env bash

set -ex

PBO="$1" ; shift 1

SRCDIR="${SRCDIR-src}"
# https://github.com/KoffeinFlummi/armake2
ARMAKE2="${ARMAKE2-armake2}"

export QUILT_PATCH_OPTS="--binary"
quilt pop -af || true

rm -rfv src/*

"$ARMAKE2" unpack "${PBO}" "${SRCDIR}"

rm -f src/\$PBOPREFIX\$
