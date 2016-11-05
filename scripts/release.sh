#!/usr/bin/env bash

targetDir=$1
sourceDir=$2
stdlibSrcDir=$3

tmpdir=`mktemp -d`

# copy to mod-dir
git archive HEAD:mod/ | tar -C "$tmpdir" -xf -
cp -a README.md "$tmpdir"

# json parsing for the poors
version=`cat $tmpdir/info.json | sed '/\"version\"/!d' | sed s/\"version\":\ //g | sed s/[\",\ ]//g`
modname=`cat $tmpdir/info.json | sed '/\"name\"/!d' | sed s/\"name\":\ //g | sed s/[\",\ ]//g`

echo "Modname:    $modname"
echo "Target-Zip: $targetDir"
echo "Source-Dir: $sourceDir"
echo "Version:    $version"
echo "Tmpdir:     $tmpdir"

# copy readme
cp -a $tmpdir/README.md $tmpdir/mod

# copy Factorio Standard-lib into release
currentDir=`pwd`
cd $stdlibSrcDir
git archive --prefix=stdlib/ HEAD:stdlib/ | tar -C "$tmpdir" -xf -
cd $currentDir


# create zip
