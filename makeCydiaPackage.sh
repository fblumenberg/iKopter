xcodebuild -configuration "Release Distribution" -target "iKopter Cydia"

PROJECTMAIN=$(pwd)
PROJECT_NAME=$(basename "${PROJECTMAIN}")
#
if [[ -f "${PROJECTMAIN}/Resources/${PROJECT_NAME}-Info.plist" ]]
then
buildPlist="${PROJECTMAIN}/Resources/${PROJECT_NAME}-Info.plist"
elif [[ -f "${PROJECTMAIN}/${PROJECT_NAME}-Info.plist" ]]
then
buildPlist="${PROJECTMAIN}/${PROJECT_NAME}-Info.plist"
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

cd ${PROJECTMAIN}/cydia/iKopter/DEBIAN
sed 's/Version:.*$/Version: '${buildVersion}'/' control > control1
echo "==============================="
mv control1 control

find ${PROJECTMAIN}/cydia -name .DS_Store -ls -exec rm {} \;
rm -Rf ${PROJECTMAIN}/cydia/repo
mkdir ${PROJECTMAIN}/cydia/repo
mkdir ${PROJECTMAIN}/cydia/repo/deb

cd ${PROJECTMAIN}/cydia
dpkg-deb -b iKopter ${PROJECTMAIN}/cydia/repo/deb/${PROJECT_NAME}Package.deb

cd ${PROJECTMAIN}/cydia/repo 
dpkg-scanpackages deb / > Packages
cat Packages
bzip2 Packages

cd ${PROJECTMAIN}



