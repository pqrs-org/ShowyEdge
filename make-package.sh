#!/bin/sh

make clean all

version=`ruby -e 'data = $stdin.read; /<key>CFBundleVersion<\/key>\s*<string>(.+?)<\/string>/m =~ data; print $1, "\n"' < build/Release/DrasticInputSourceStatus.app/Contents/Info.plist`

# --------------------------------------------------
echo "Making dmg..."

rm -f DrasticInputSourceStatus-$version.dmg
hdiutil create -nospotlight DrasticInputSourceStatus-$version.dmg -srcfolder build/Release/DrasticInputSourceStatus.app
chmod 644 DrasticInputSourceStatus-$version.dmg
