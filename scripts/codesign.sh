#!/bin/bash

set -u # forbid undefined variables
set -e # forbid command failure

readonly PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH

#
# Set codesign identity from environment variables.
#

if [[ -n "${PQRS_ORG_CODE_SIGN_IDENTITY:-}" ]]; then
    CODE_SIGN_IDENTITY="${PQRS_ORG_CODE_SIGN_IDENTITY:-}"
else
    CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY:-}"
fi

#
# Skip if identity is not set
#

if [[ -z "$CODE_SIGN_IDENTITY" ]]; then
    echo "Skip codesign"
    exit 0
fi

err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

main() {
    if [[ ! -e "$1" ]]; then
        err "Invalid argument: '$1'"
        exit 1
    fi

    #
    # Sign with codesign
    #

    cd "$1"
    find * -name '*.app' -or -path '*/bin/*' | sort -r | while read f; do
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

        set +e # allow command failure

        codesign \
            --force \
            --deep \
            --options runtime \
            --sign "$CODE_SIGN_IDENTITY" \
            "$f" 2>&1 |
            grep -v ': replacing existing signature'

        set -e # forbid command failure

        echo -ne '\033[0m'
    done

    #
    # Verify codesign
    #

    find * -name '*.app' -or -path '*/bin/*' | sort -r | while read f; do
        echo -ne '\033[31;40m'
        codesign --verify --deep "$f"
        echo -ne '\033[0m'
    done
}

main "$1"
