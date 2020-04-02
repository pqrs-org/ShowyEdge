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

### Step1: Getting source code

Execute a following command in Terminal.app.

```shell
git clone --depth 1 https://github.com/pqrs-org/ShowyEdge.git
```

### Step2: Building a package

Execute a following command in Terminal.app.

```shell
cd ShowyEdge
make
```

Then, ShowyEdge-VERSION.dmg has been created in the current directory.
It's a distributable package.
