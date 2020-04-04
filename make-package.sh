#!/bin/bash

set -u # forbid undefined variables
set -e # forbid command failure

#
# Execute make command
#

cd $(dirname $0)

version=$(cat version)

echo "make clean build"
make clean build | ruby scripts/reduce-logs.rb
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    exit 99
fi

#
# Create dmg
#

dmg=ShowyEdge-$version.dmg

rm -f $dmg
rm -rf tmp
mkdir -p tmp

# copy files
rsync -a src/server/build_xcode/build/Release/ShowyEdge.app tmp
mkdir tmp/ShowyEdge.app/Contents/Applications
rsync -a src/preferences/build_xcode/build/Release/ShowyEdge.app/ \
    "tmp/ShowyEdge.app/Contents/Applications/ShowyEdge Preferences.app"

# codesign
bash scripts/codesign.sh tmp

# create-dmg
if [[ -n "${PQRS_ORG_CODE_SIGN_IDENTITY:-}" ]]; then
    # find identity for create-dmg
    identity=$(security find-identity -v -p codesigning | grep 8D660191481C98F5C56630847A6C39D95C166F22 | grep -oE '"[^"]+"$' | sed 's|^"||' | sed 's|"$||')
    create-dmg --overwrite --identity="$identity" tmp/ShowyEdge.app
else
    # create-dmg is always failed if codesign identity is not found.
    set +e # allow command failure
    create-dmg --overwrite tmp/ShowyEdge.app
    set -e # forbid command failure
fi

# clean
rm -rf tmp
mv "ShowyEdge $version.dmg" ShowyEdge-$version.dmg
