#CONFIGURATION = Debug
CONFIGURATION = Release

all:
	xcodebuild -alltargets -configuration $(CONFIGURATION) build

clean:
	rm -rf build
	rm -f *.xcodeproj/*.mode1
	rm -f *.xcodeproj/*.mode1v3
	rm -f *.xcodeproj/*.pbxuser
	rm -f *.app.zip

run: all
	open ./build/Release/DrasticInputSourceStatus.app/Contents/MacOS/DrasticInputSourceStatus

package:
	./make-package.sh
