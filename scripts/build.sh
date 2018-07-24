#!/bin/bash

# Grab the MACHINE from the environment; otherwise, set it to a sane default
export MACHINE="${MACHINE-qemux86-64}"

# What to build
BUILD_TARGETS="
    core-image-minimal-ibm \
    core-image-minimal-aws \
    core-image-minimal-google \
"

die() {
    echo "$*" >&2
    exit 1
}

rm -f build/conf/bblayers.conf || die "failed to nuke bblayers.conf"
rm -f build/conf/local.conf || die "failed to nuke local.conf"

mkdir -p artifacts

./scripts/containerize.sh bitbake -k ${BUILD_TARGETS} || die "failed to build"

for target in ${BUILD_TARGETS}; do
    echo cp build/tmp/deploy/images/$MACHINE/${target}-${MACHINE}.* artifacts
done

exit 0

