#CONFIGURATION = Debug
CONFIGURATION = Release

all: build_xcode

clean: clean_builds

run: all
	bash ../../scripts/codesign.sh build_xcode/build
	./build_xcode/build/Release/ShowyEdge.app/Contents/MacOS/ShowyEdge

include ../Makefile.rules
