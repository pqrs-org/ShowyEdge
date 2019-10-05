[![Build Status](https://travis-ci.org/tekezo/ShowyEdge.svg?branch=master)](https://travis-ci.org/tekezo/ShowyEdge)
[![License](https://img.shields.io/badge/license-Public%20Domain-blue.svg)](https://github.com/tekezo/ShowyEdge/blob/master/LICENSE.md)

# ShowyEdge

ShowyEdge displays a color bar at the top edge of the screen depending on the current input source.
You can recognize the current input source very easily even if you are using fullscreen apps.

## Web pages

-   master: <https://pqrs.org/osx/ShowyEdge/>
-   backup: <http://tekezo.github.io/pqrs.org/>

You can also get the latest stable release package via fixed URL.

```shell
curl -L -O https://pqrs.org/latest/showyedge-latest.dmg
```

## System requirements

Mac OS X 10.9 or higher.

## How to build

System Requirements:

-   OS X 10.13+
-   Xcode 10
-   Command Line Tools for Xcode
-   CMake (`brew install cmake`)

### Step1: Getting source code

Execute a following command in Terminal.app.

```shell
git clone --depth 1 https://github.com/tekezo/ShowyEdge.git
```

### Step2: Building a package

Execute a following command in Terminal.app.

```shell
cd ShowyEdge
make
```

Then, ShowyEdge-VERSION.dmg has been created in the current directory.
It's a distributable package.
