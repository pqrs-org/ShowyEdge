all:
	/usr/bin/python3 ../scripts/update-version.py
	bash run-xcodegen.sh
	$(MAKE) -C vendor
	xcodebuild -configuration Release -alltargets SYMROOT="$(CURDIR)/build"

clean:
	$(MAKE) -C vendor clean
	rm -rf ShowyEdge.xcodeproj
	rm -rf build

xcode:
	open ShowyEdge.xcodeproj

run:
	bash ../scripts/codesign.sh build/Release
	open build/Release/ShowyEdge.app
