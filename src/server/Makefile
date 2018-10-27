AUTOUPDATE_ICON = 'build_xcode/build/Release/ShowyEdge.app/Contents/Frameworks/Sparkle.framework/Versions/A/Resources/Autoupdate.app/Contents/Resources/AppIcon.icns'

all:
	make build_xcode
	install -m 644 Resources/app.icns $(AUTOUPDATE_ICON)

clean: clean_builds

run: all
	./build_xcode/build/Release/ShowyEdge.app/Contents/MacOS/ShowyEdge

include ../Makefile.rules
