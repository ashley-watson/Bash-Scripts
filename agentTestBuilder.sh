#!/bin/bash

# Grabbing current release of Datadog agent installed & setting variables
#
currentInstalled=$(pacman -Qs datadog | awk '{print $2}' | head -n1 | cut -c 1-6)
pkgFile=(/home/ashley/Dev\ Stuff/DDogAgent\ Builds/PKGBUILD)
Version=$(curl -s https://apt.datadoghq.com/dists/stable/7/binary-arm64/Packages | sed -n '/^Package: datadog-agent$/,/SHA256:*/p' | grep -vwi "dbg\|heroku\|iot\|license\|dogstatsd\|architecture\|recommends\|section\|priority\|filename\|installed-size\|size\|sha1\|maintainer\|homepage\|vendor" | tail -n 2 | head -n1 | awk '{print $2}' | cut -c 3-8)
armSha=$(curl -s https://apt.datadoghq.com/dists/stable/7/binary-arm64/Packages | sed -n '/^Package: datadog-agent$/,/SHA256:*/p' | grep -vwi "dbg\|heroku\|iot\|license\|dogstatsd\|architecture\|recommends\|section\|priority\|filename\|installed-size\|size\|sha1\|maintainer\|homepage\|vendor" | tail -n 1 | awk '{print $2}')
amdSha=$(curl -s https://apt.datadoghq.com/dists/stable/7/binary-amd64/Packages | sed -n '/^Package: datadog-agent$/,/SHA256:*/p' | grep -vwi "dbg\|heroku\|iot\|license\|dogstatsd\|architecture\|recommends\|section\|priority\|filename\|installed-size\|size\|sha1\|maintainer\|homepage\|vendor" | tail -n 1 | awk '{print $2}')
oldVersion=$(grep -i pkgver /home/ashley/Dev\ Stuff/DDogAgent\ Builds/PKGBUILD | head -n1 | cut -c 8-13)
oldAmdHash=$(grep -i -A1 sha256sums_x86_64 /home/ashley/Dev\ Stuff/DDogAgent\ Builds/PKGBUILD | tail -n1 | sed "s/ //g" | sed "s/'//g" | sed "s/)//g")
oldArmHash=$(grep -i -A1 sha256sums_aarch64 /home/ashley/Dev\ Stuff/DDogAgent\ Builds/PKGBUILD | tail -n1 | sed "s/ //g" | sed "s/'//g" | sed "s/)//g")


# Outputting data to verify correct information is pulled
echo "Current Version: $currentInstalled"
echo "Current ARM Sha: $armSha"
echo "Current AMD Sha: $amdSha"
echo "Old Version from PKGBUILD: $oldVersion"
echo "Old AMD Sha: $oldAmdHash"
echo "Old ARM Sha: $oldArmHash"
echo "Currently available release of the agent: $Version"

# Running the build and install for testing if upgraded correctly
/usr/bin/makepkg -c -i PKGBUILD

upgradeVersion=$(pacman -Qs datadog | awk '{print $2}' | head -n1 | cut -c 1-6)

echo "Upgraded Version installed: $upgradeVersion"

if [[ "$currentInstalled" == "$upgradeVersion" ]]
then
	echo "Nothing updated. Exiting.."
else
	echo "Agent successfully upgraded!"
fi
