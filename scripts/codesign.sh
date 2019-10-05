#!/bin/bash

CODESIGN_IDENTITY='8D660191481C98F5C56630847A6C39D95C166F22'

# ------------------------------------------------------------
PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH

if [ ! -e "$1" ]; then
    echo "[ERROR] Invalid argument: '$1'"
    exit 1
fi

# ------------------------------------------------------------
# sign
cd "$1"
find * -name '*.app' -or -name '*.signed.kext' -or -path '*/bin/*' | sort -r | while read f; do
    #
    # output message
    #

    echo -ne '\033[33;40m'
    echo "code sign $f"
    echo -ne '\033[0m'

    #
    # codesign
    #

    echo -ne '\033[31;40m'

    codesign \
        --force \
        --deep \
        --options runtime \
        --sign "$CODESIGN_IDENTITY" \
        "$f" 2>&1 |
        grep -v ': replacing existing signature'

    echo -ne '\033[0m'
done

# verify
find * -name '*.app' -or -name '*.signed.kext' -or -path '*/bin/*' | sort -r | while read f; do
    echo -ne '\033[31;40m'
    codesign --verify --deep "$f"
    echo -ne '\033[0m'
done
