#!/usr/bin bash
# 
# release.sh <sourceDir> <stdlibSrcDir> <targetDir> 
# 
# sourceDir is the git-repository-root-dir of your mod. It must include a mod-subdir, which contains info.json etc.
# stdlibSrcDir is the git-repository-root-dir of the FactorioStandard-Lib. The stdlib is copied into your mod-dir.
# targetDir is the target-directory where the zipped mod should be placed. 
# 
# Example call:
# > source scripts/release.sh . ../Factorio-Stdlib/ /tmp
#
# Calling this script via source-command is only needed if you don't set the x-bits of this script.
# 


sourceDir=$1
stdlibSrcDir=$2
targetDir=$3

tmpdir=`mktemp -d`

currentDir=`pwd`
cd "$sourceDir"

# json parsing for the poors
version=`cat mod/info.json | sed '/\"version\"/!d' | sed s/\"version\":\ //g | sed s/[^0-9\.]//g`
modname=`cat mod/info.json | sed '/\"name\"/!d' | sed s/\"name\":\ //g | sed s/[^A-Za-z0-9-]//g`
fullName="$modname""_$version"

cd "$currentDir"
cd "$targetDir"
targetDir=`pwd`
cd "$currentDir"
targetZip="$targetDir/$fullName.zip"

echo "Modname:    $modname"
echo "Version:    $version"
echo "Tmpdir:     $tmpdir"
echo "Target-Zip: $targetZip"

# copy to mod-dir
cd "$sourceDir"
git archive --prefix="$fullName/" HEAD:mod | tar -C "$tmpdir" -xf -
cp README.md "$tmpdir/$fullName"
cp Changelog "$tmpdir/$fullName"
cd "$currentDir"


# copy Factorio Standard-lib into release
cd "$stdlibSrcDir"
git archive --prefix="$fullName/stdlib/" HEAD:stdlib/ | tar -C "$tmpdir" -xf -
cd "$currentDir"

# create zip
cd "$tmpdir"
if [ -f "$targetZip" ] ; then
    rm "$targetDir/$fullName.zip"
fi
zip -q -r "$targetZip" .
cd "$currentDir"

echo "Done."
