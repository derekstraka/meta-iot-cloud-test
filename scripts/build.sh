#!/bin/bash

# Grab the MACHINE from the environment; otherwise, set it to a sane default
export MACHINE="${MACHINE-qemux86-64}"

# What to build
BUILD_TARGETS="
    core-image-minimal-ibm \
    core-image-minimal-aws \
    core-image-minimal-azure \
    core-image-minimal-google \
"

die() {
    echo "$*" >&2
    exit 1
}

rm -f build/conf/bblayers.conf || die "failed to nuke bblayers.conf"
rm -f build/conf/local.conf || die "failed to nuke local.conf"

mkdir -p artifacts

./scripts/containerize.sh "bitbake ${BUILD_TARGETS} -c checkpkg && cp tmp/log/checkpkg.csv ../artifacts/iot-cloud-packages-checkpkg.csv"

./scripts/containerize.sh bitbake -k ${BUILD_TARGETS} || die "failed to build"

zip -r ../artifacts/${MACHINE}.zip build/tmp/deploy/images/$MACHINE/

exit 0

