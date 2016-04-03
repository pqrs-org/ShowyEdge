#CONFIGURATION = Debug
CONFIGURATION = Release

AUTOUPDATE_ICON = 'build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/A/Resources/Autoupdate.app/Contents/Resources/AppIcon.icns'

all:
	$(MAKE) -C ../../pkginfo
	(cd Pods && xcodebuild -configuration $(CONFIGURATION) SYMROOT=$(CURDIR)/build)
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

podupdate:
	pod update
	pod install --no-repo-update
