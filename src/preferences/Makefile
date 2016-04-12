#CONFIGURATION = Debug
CONFIGURATION = Release

all:
	$(MAKE) -C ../../pkginfo
	xcodebuild -alltargets -configuration $(CONFIGURATION) build

clean:
	rm -rf build

gitclean:
	git clean -f -x -d

xcode:
	open *.xcodeproj

run: all
	"./build/Release/ShowyEdge Preferences.app/Contents/MacOS/ShowyEdge Preferences"

package:
	./make-package.sh
