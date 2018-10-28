#!/bin/bash

version=$(cat version)

echo "make clean build"
make clean build | ruby scripts/reduce-logs.rb
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    exit 99
fi

# --------------------------------------------------
echo "Making dmg..."

pkgroot="ShowyEdge-$version"

rm -f $pkgroot.dmg
rm -rf $pkgroot
mkdir $pkgroot

# copy files
rsync -a src/server/build_xcode/build/Release/ShowyEdge.app $pkgroot
mkdir $pkgroot/ShowyEdge.app/Contents/Applications
rsync -a "src/preferences/build_xcode/build/Release/ShowyEdge-Preferences.app/" \
  "$pkgroot/ShowyEdge.app/Contents/Applications/ShowyEdge Preferences.app"

sh scripts/setpermissions.sh $pkgroot

# codesign
bash scripts/codesign.sh $pkgroot

# add symbolic link
ln -s /Applications $pkgroot/Applications

# make dmg
hdiutil create -nospotlight ShowyEdge-$version.dmg -srcfolder $pkgroot
chmod 644 $pkgroot.dmg

# clean
rm -rf $pkgroot
