#CONFIGURATION = Debug
CONFIGURATION = Release

all:
	xcodebuild -alltargets -configuration $(CONFIGURATION) build

clean:
	git clean -f -x -d

xcode:
	open *.xcodeproj

run: all
	./build/Release/ShowyEdge.app/Contents/MacOS/ShowyEdge

package:
	./make-package.sh
