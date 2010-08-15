#!/bin/sh

make clean all

version=`ruby -e 'data = $stdin.read; /<key>CFBundleVersion<\/key>\s*<string>(.+?)<\/string>/m =~ data; print $1, "\n"' < build/Release/DrasticInputSourceStatus.app/Contents/Info.plist`
(cd build/Release; zip -r DrasticInputSourceStatus-$version.app.zip DrasticInputSourceStatus.app)
mv build/Release/DrasticInputSourceStatus-$version.app.zip .
chmod 644 DrasticInputSourceStatus-$version.app.zip
