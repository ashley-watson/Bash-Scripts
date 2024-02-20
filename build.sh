#!/bin/bash

# Grabbing values to input into PKGBUILD file

file=/path/to/PKGBUILD
Version=$(curl --silent "https://github.com/DataDog/datadog-agent/releases" | grep -iE "DataDog/datadog-agent/tree/" | awk '{print $2}' | cut -c "35-40" | head -n1)
armSha=$(curl -s https://apt.datadoghq.com/dists/stable/7/binary-arm64/Packages | sed -n '/^Package: datadog-agent$/,/SHA256:*/p' | grep -vwi "dbg\|heroku\|iot\|license\|dogstatsd\|architecture\|recommends\|section\|priority\|filename\|installed-size\|size\|sha1\|maintainer\|homepage\|vendor" | tail -n 1 | awk '{print $2}')
amdSha=$(curl -s https://apt.datadoghq.com/dists/stable/7/binary-amd64/Packages | sed -n '/^Package: datadog-agent$/,/SHA256:*/p' | grep -vwi "dbg\|heroku\|iot\|license\|dogstatsd\|architecture\|recommends\|section\|priority\|filename\|installed-size\|size\|sha1\|maintainer\|homepage\|vendor" | tail -n 1 | awk '{print $2}')
oldVersion=$(grep -i pkgver /path/to/PKGBUILD | head -n1 | cut -c 8-13)
oldAmdHash=$(grep -i -A1 sha256sums_x86_64 /path/to/PKGBUILD | tail -n1 | sed "s/ //g" | sed "s/'//g" | sed "s/)//g")
oldArmHash=$(grep -i -A1 sha256sums_aarch64 /path/to/PKGBUILD | tail -n1 | sed "s/ //g" | sed "s/'//g" | sed "s/)//g")

# Starting time for trace duration calculation
StartTime=$(date +%s)

# Outputting data to verify correct information is pulled
echo "File path: $file"
echo "Current Version: $Version"
echo "Current ARM Sha: $armSha"
echo "Current AMD Sha: $amdSha"
echo "Old Version from PKGBUILD: $oldVersion"
echo "Old AMD Sha: $oldAmdHash"
echo "Old ARM Sha: $oldArmHash"

# Updating PKGBUILD with gathered variables
read -p "Update PKGBUILD? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
echo "Updating PKGBUILD"
sed -i "s/$oldVersion/$Version/g" "$file"
sed -i "s/$oldAmdHash/$amdSha/g" "$file"
sed -i "s/$oldArmHash/$armSha/g" "$file"
sleep 2
echo "PKGBUILD Updated!"
echo "Ready to commit to AUR"

# Building and committing the package
#
read -p "Continue to commit? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
read -p "Enter commit messsage: " comMsg
echo "Waiting 10 seconds before committing to allow time to cancel"
sleep 10
echo "Updating ...."
makepkg --printsrcinfo > .SRCINFO
sleep 5
git add PKGBUILD .SRCINFO
sleep 5
git commit -m "$comMsg"
sleep 5
git push
sleep 5
echo "Commit pushed! Please check the AUR to make sure the commit took properly!"
echo "Done!"

# Ending time and calculating trace duration
#
#EndTime=$(date +%s)
#duration=$(($EndTime-$StartTime))
#spanId=$(date +%s)
#traceId=$(date +%s)

# Sending trace to Datadog
#
#curl -X PUT "http://localhost:8126/v0.3/traces" \
#-H "Content-Type: application/json" \
#-d @- << EOF
#[
#  [
#    {
#      "duration": $duration,
#      "name": "ArchDDogAgent",
#      "resource": "/builder",
#      "service": "agent_checker",
#      "span_id": $spanId,
#      "trace_id": $traceId,
#      "type": "custom"
#    }
#  ]
#]
#EOF
