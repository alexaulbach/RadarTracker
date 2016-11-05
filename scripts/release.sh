#!/usr/bin/env bash

sourceDir=$1
stdlibSrcDir=$2
targetDir=$3

tmpdir=`mktemp -d`

# copy to mod-dir
currentDir=`pwd`
cd "$sourceDir"

# json parsing for the poors
version=`cat mod/info.json | sed '/\"version\"/!d' | sed s/\"version\":\ //g | sed s/[\",\ ]//g`
modname=`cat mod/info.json | sed '/\"name\"/!d' | sed s/\"name\":\ //g | sed s/[\",\ ]//g`
fullName="$modname""_$version"

cd "$currentDir"
cd "$targetDir"
targetDir=`pwd`
cd "$currentDir"

echo "Modname:    $modname"
echo "Version:    $version"
echo "Tmpdir:     $tmpdir"
echo "Target-Zip: $targetDir/$fullName"

cd "$sourceDir"
git archive --prefix="$fullName" HEAD:mod | tar -C "$tmpdir" -xf -
cp README.md "$tmpdir/$fullName"
cd "$currentDir"


# copy Factorio Standard-lib into release
cd "$stdlibSrcDir"
git archive --prefix="$fullName/stdlib/" HEAD:stdlib/ | tar -C "$tmpdir" -xf -
cd "$currentDir"

# create zip
cd "$tmpdir"
rm "$targetDir/$fullName"
zip -q -r "$targetDir/$fullName.zip" .
cd "$currentDir"
