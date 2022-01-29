#!/bin/sh

set -u

for f in $(dirname $0)/../ShowyEdge-*.dmg; do
    if [ -f $f ]; then
        basename $f

        if xcrun notarytool \
            submit $(basename $f) \
            --keychain-profile "pqrs.org notarization" \
            --wait \
            ; then
            xcrun stapler staple $(basename $f)
            say "notarization completed"
        fi
    fi
done
