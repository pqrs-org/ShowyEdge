#CONFIGURATION = Debug
CONFIGURATION = Release

all:
	xcodebuild -alltargets -configuration $(CONFIGURATION) build

clean:
	git clean -f -x -d

xcode:
	open *.xcodeproj

run: all
	./build/Release/DrasticInputSourceStatus.app/Contents/MacOS/DrasticInputSourceStatus

package:
	./make-package.sh
