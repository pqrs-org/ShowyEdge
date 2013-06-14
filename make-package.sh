#!/bin/sh

make clean all

version=`ruby -e 'data = $stdin.read; /<key>CFBundleVersion<\/key>\s*<string>(.+?)<\/string>/m =~ data; print $1, "\n"' < build/Release/ShowyEdge.app/Contents/Info.plist`

# --------------------------------------------------
echo "Making dmg..."

rm -f ShowyEdge-$version.dmg
hdiutil create -nospotlight ShowyEdge-$version.dmg -srcfolder build/Release/ShowyEdge.app
chmod 644 ShowyEdge-$version.dmg
