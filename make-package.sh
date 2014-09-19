#!/bin/sh

# set $GEM_HOME/bin/ for CocoaPods.
PATH="/bin:/sbin:/usr/bin:/usr/sbin:$GEM_HOME/bin"; export PATH

make clean all

version=`ruby -e 'data = $stdin.read; /<key>CFBundleVersion<\/key>\s*<string>(.+?)<\/string>/m =~ data; print $1, "\n"' < build/Release/ShowyEdge.app/Contents/Info.plist`

# --------------------------------------------------
echo "Making dmg..."

pkgroot="ShowyEdge-$version"

rm -f $pkgroot.dmg
rm -rf $pkgroot
mkdir $pkgroot

# codesign
bash files/extra/codesign.sh build/Release

# copy files
rsync -a build/Release/ShowyEdge.app $pkgroot
ln -s /Applications $pkgroot/Applications

sh files/extra/setpermissions.sh $pkgroot

# make dmg
hdiutil create -nospotlight ShowyEdge-$version.dmg -srcfolder $pkgroot
chmod 644 $pkgroot.dmg

# clean
rm -rf $pkgroot
