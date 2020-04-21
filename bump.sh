#!/usr/bin/env bash

set -e

export TZ=UTC

NEW_VER_FORK="${1-$(date -I)}"

SRCDIR="${SRCDIR-src}"

export QUILT_PATCH_OPTS="--binary"
quilt push -f 99-version.patch
VER_FORK="${VER_FORK-$(grep -Po '(?<=downstreamVersion = ")[^"]+' src/description.ext)}"
quilt pop -af

if [[ -z $VER_FORK || -z $NEW_VER_FORK ]] ; then
  echo "[!] Empty version: VER_FORK=\"$VER_FORK\" NEW_VER_FORK=\"$NEW_VER_FORK\"" 1>&2
  exit 1
fi

if [[ $VER_FORK = "$NEW_VER_FORK" ]]; then
  echo "[!] Versions are equal: $VER_FORK = $NEW_VER_FORK" 1>&2
  exit 1
fi

BUMPTEXT="$VER_FORK -> $NEW_VER_FORK"
sed -E -i "/downstreamVersion|briefingName/ s/$VER_FORK/$NEW_VER_FORK/g" patches/99-version.patch

git reset HEAD -- .
git add -f -- patches/99-version.patch
git diff --cached --stat --patch

# shellcheck disable=SC2162
read -p "Ready to commit ($BUMPTEXT), press Ctrl-C to cancel"
git commit -m "Bump downstream: $BUMPTEXT"
