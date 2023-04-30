#!/bin/bash

set -u # forbid undefined variables
set -e # forbid command failure

#
# Execute make command
#

cd $(dirname $0)

version=$(cat version)

echo "make build"
make build
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    exit 99
fi

#
# Create dmg
#

dmg=ShowyEdge-$version.dmg

rm -f $dmg

# create-dmg
if [[ -n "${PQRS_ORG_CODE_SIGN_IDENTITY:-}" ]]; then
    # find identity for create-dmg
    identity=$(security find-identity -v -p codesigning | grep "${PQRS_ORG_CODE_SIGN_IDENTITY}" | grep -oE '"[^"]+"$' | sed 's|^"||' | sed 's|"$||')
    create-dmg --overwrite --identity="$identity" src/build/Release/ShowyEdge.app
else
    # create-dmg is always failed if codesign identity is not found.
    set +e # allow command failure
    create-dmg --overwrite src/build/Release/ShowyEdge.app
    set -e # forbid command failure
fi

mv "ShowyEdge $version.dmg" ShowyEdge-$version.dmg
