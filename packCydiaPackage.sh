PROJECTMAIN=$(pwd)
PROJECT_NAME="iKopter"
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

PROJECT_NAME="iKopter3G"
APPMAIN=${PROJECTMAIN}/Cydia/iKopter3G/Applications/${PROJECT_NAME}.app
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
/usr/local/bin/dpkg-deb -b iKopter ${PROJECTMAIN}/Cydia/repo/deb/iKopterPackage.deb
/usr/local/bin/dpkg-deb -b iKopter3G ${PROJECTMAIN}/Cydia/repo/deb/iKopter3GPackage.deb

cd ${PROJECTMAIN}/Cydia/repo 
/usr/local/bin/dpkg-scanpackages deb / > Packages
cat Packages
bzip2 Packages

cd ${PROJECTMAIN}



