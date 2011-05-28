./plistVersionIncrement.sh

xcodebuild -configuration "Release Distribution" -target "iKopter"

PROJECTMAIN=$(pwd)
PROJECT_NAME=$(basename "${PROJECTMAIN}")
APPMAIN=${PROJECTMAIN}/Cydia/iKopter/Applications/${PROJECT_NAME}.app
#
if [[ -f "${APPMAIN}/Info.plist" ]]
then
buildPlist="${APPMAIN}/Info.plist"
else
echo -e "Can't find the plist: ${PROJECT_NAME}-Info.plist"
exit 1
fi
#
buildVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${buildPlist}" 2>/dev/null)
if [[ "${buildVersion}" = "" ]]
then
echo -e "\"${buildPlist}\" does not contain key: \"CFBundleVersion\""
exit 1
fi

cd ${PROJECTMAIN}/Cydia/iKopter/DEBIAN
sed 's/Version:.*$/Version: '${buildVersion}'/' control > control1
echo "==============================="
mv control1 control

find ${PROJECTMAIN}/Cydia -name .DS_Store -ls -exec rm {} \;
rm -Rf ${PROJECTMAIN}/Cydia/repo
mkdir ${PROJECTMAIN}/Cydia/repo
mkdir ${PROJECTMAIN}/Cydia/repo/deb

cd ${PROJECTMAIN}/Cydia
dpkg-deb -b iKopter ${PROJECTMAIN}/Cydia/repo/deb/${PROJECT_NAME}Package.deb

cd ${PROJECTMAIN}/Cydia/repo 
dpkg-scanpackages deb / > Packages
cat Packages
bzip2 Packages

cd ${PROJECTMAIN}



