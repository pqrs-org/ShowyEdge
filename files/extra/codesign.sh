#!/bin/bash

CODESIGN_IDENTITY='8ECD43BA902B40380BD84C4512385E6C5EB3F160'

# ------------------------------------------------------------
PATH=/bin:/sbin:/usr/bin:/usr/sbin; export PATH

if [ ! -e "$1" ]; then
    echo "[ERROR] Invalid argument: '$1'"
    exit 1
fi

# ------------------------------------------------------------
# sign
targets=`find "$1" -name '*.app' -or -name '*.signed.kext' -or -path '*/bin/*' | sort -r`

for f in $targets; do
    echo -ne '\033[33;40m'
    echo "code sign $f"
    echo -ne '\033[0m'

    echo -ne '\033[31;40m'
    codesign \
        --force \
        --deep \
        --sign "$CODESIGN_IDENTITY" \
        "$f"
    echo -ne '\033[0m'
done

# verify
for f in $targets; do
    echo -ne '\033[31;40m'
    codesign --verify --deep "$f"
    echo -ne '\033[0m'
done
