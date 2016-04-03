#!/bin/bash

# set $GEM_HOME/bin/ for CocoaPods.
PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:$GEM_HOME/bin"; export PATH

version=$(cat version)

echo "make clean build"
make clean build | ruby files/extra/reduce-logs.rb
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
rsync -a src/server/build/Release/ShowyEdge.app $pkgroot

sh files/extra/setpermissions.sh $pkgroot

# codesign
bash files/extra/codesign.sh $pkgroot

# add symbolic link
ln -s /Applications $pkgroot/Applications

# make dmg
hdiutil create -nospotlight ShowyEdge-$version.dmg -srcfolder $pkgroot
chmod 644 $pkgroot.dmg

# clean
rm -rf $pkgroot
