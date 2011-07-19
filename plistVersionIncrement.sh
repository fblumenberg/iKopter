#!/bin/bash
#
# @(#)  Increment the version number in the project plist.
#               Note:   The project plist could be in directory
#                               "Resources" or the project root.
#                               Personally, I avoid clutter in the project root.
#               Enjoy! xaos@xm5design.com
#
PROJECTMAIN=$(pwd)
#
if [[ -f "${PROJECTMAIN}/${INFOPLIST_FILE}" ]]
then
	buildPlist="${PROJECTMAIN}/${INFOPLIST_FILE}"
else
	echo -e "Can't find the plist: ${PROJECTMAIN}/${INFOPLIST_FILE}"
exit 1
fi
#
buildVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${buildPlist}" 2>/dev/null)
if [[ "${buildVersion}" = "" ]]
then
	echo -e "\"${buildPlist}\" does not contain key: \"CFBundleVersion\""
	exit 1
fi
IFS='.'
set $buildVersion
MAJOR_VERSION="${1}.${2}.${3}"
MINOR_VERSION="${4}"
buildNumber=$(($MINOR_VERSION + 1))
buildNewVersion="${MAJOR_VERSION}.${buildNumber}"
echo -e "${PROJECT_NAME}: Old version number: ${buildVersion} New Version Number: ${buildNewVersion}"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${buildNewVersion}" "${buildPlist}"

