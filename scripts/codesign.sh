#!/bin/bash

set -u # forbid undefined variables
set -e # forbid command failure

readonly PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH

readonly CODE_SIGN_IDENTITY=$(bash $(dirname $0)/get-codesign-identity.sh)

if [[ -z $CODE_SIGN_IDENTITY ]]; then
    echo "Skip codesign"
    exit 0
fi

#
# Define do_codesign
#

do_codesign() {
    echo -ne '\033[31;40m'

    set +e # allow command failure

    local entitlements=""
    if [[ -n "$2" ]]; then
        entitlements="--entitlements $2"
    fi

    codesign \
        --force \
        --options runtime \
        --sign "$CODE_SIGN_IDENTITY" \
        $entitlements \
        "$1" 2>&1 |
        grep -v ': replacing existing signature'

    set -e # forbid command failure

    echo -ne '\033[0m'
}

#
# Run
#

set +u # allow undefined variables
target_path="$1"
entitlements_path="$2"
set -u # forbid undefined variables

do_codesign "$target_path" "$entitlements_path"
