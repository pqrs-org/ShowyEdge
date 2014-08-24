#CONFIGURATION = Debug
CONFIGURATION = Release

all:
	pod install --no-repo-update
	xcodebuild \
		-workspace *.xcworkspace \
		-scheme ShowyEdge \
		-configuration $(CONFIGURATION) \
		build \
		SYMROOT=`pwd`/build

clean:
	rm -rf build

gitclean:
	git clean -f -x -d

xcode:
	open *.xcworkspace

run: all
	./build/Release/ShowyEdge.app/Contents/MacOS/ShowyEdge

package:
	./make-package.sh
