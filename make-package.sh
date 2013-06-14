#!/bin/sh

make clean all

version=`ruby -e 'data = $stdin.read; /<key>CFBundleVersion<\/key>\s*<string>(.+?)<\/string>/m =~ data; print $1, "\n"' < build/Release/ShowyEdge.app/Contents/Info.plist`

# --------------------------------------------------
echo "Making dmg..."

pkgroot="ShowyEdge-$version"

rm -f $pkgroot.dmg
rm -rf $pkgroot
mkdir $pkgroot
rsync -a build/Release/ShowyEdge.app $pkgroot
ln -s /Applications $pkgroot/Applications
hdiutil create -nospotlight ShowyEdge-$version.dmg -srcfolder $pkgroot
chmod 644 $pkgroot.dmg
rm -rf $pkgroot
