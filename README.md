[![Build Status](https://github.com/pqrs-org/ShowyEdge/workflows/ShowyEdge%20CI/badge.svg)](https://github.com/pqrs-org/ShowyEdge/actions)
[![License](https://img.shields.io/badge/license-Public%20Domain-blue.svg)](https://github.com/pqrs-org/ShowyEdge/blob/master/LICENSE.md)

# ShowyEdge

ShowyEdge displays a color bar at the top edge of the screen depending on the current input source.
You can recognize the current input source very easily even if you are using fullscreen apps.

## Web pages

<https://showyedge.pqrs.org/>

## System requirements

macOS 10.9 or later

## How to build

System Requirements:

-   OS X 10.15+
-   Xcode 11+
-   Command Line Tools for Xcode
-   CMake (`brew install cmake`)
-   [create-dmg](https://github.com/sindresorhus/create-dmg)

### Steps

1.  Get source code by executing a following command in Terminal.app.

    ```shell
    git clone --depth 1 https://github.com/pqrs-org/ShowyEdge.git
    ```

2.  Find your codesign identity if you have one.<br />
    (Skip this step if you don't have your codesign identity.)

    ```shell
    security find-identity -p codesigning -v | grep 'Developer ID Application'
    ```

    The result is as follows.

    ```text
    1) 8D660191481C98F5C56630847A6C39D95C166F22 "Developer ID Application: Fumihiko Takayama (G43BCU2T37)"
    ```

    Your codesign identity is `8D660191481C98F5C56630847A6C39D95C166F22` in the above case.

3.  Set environment variable to use your codesign identity.<br />
    (Skip this step if you don't have your codesign identity.)

    ```shell
    export PQRS_ORG_CODE_SIGN_IDENTITY=8D660191481C98F5C56630847A6C39D95C166F22
    ```

4.  Build a package by executing a following command in Terminal.app.

    ```shell
    cd ShowyEdge
    make clean all
    ```

    Then, ShowyEdge-VERSION.dmg has been created in the current directory.
    It's a distributable package.

    Note: If you don't have codesign identity, the dmg works only on your machine.
