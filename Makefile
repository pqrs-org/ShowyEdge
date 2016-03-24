#CONFIGURATION = Debug
CONFIGURATION = Release

AUTOUPDATE_ICON = 'build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/A/Resources/Autoupdate.app/Contents/Resources/AppIcon.icns'

all:
	(cd Pods && xcodebuild -configuration $(CONFIGURATION) SYMROOT=`pwd`/../build)
	xcodebuild -alltargets -configuration $(CONFIGURATION) build
	[ -f $(AUTOUPDATE_ICON) ] || exit 1
	install -m 644 Resources/app.icns $(AUTOUPDATE_ICON)

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

podupdate:
	pod update
	pod install --no-repo-update

ibtool-upgrade:
	find * -name '*.xib' | while read f; do xcrun ibtool --upgrade "$$f"; done
