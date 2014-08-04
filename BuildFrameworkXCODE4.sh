#!/bin/bash

echo "#Setting Variables"
echo target=libGOPS
echo target2=GOPS_SDK
echo configuration=Distribution
echo configuration2=Release
echo sdk=iphoneos6.1
echo sdk2=iphonesimulator6.1
echo sdk3=iphonesimulator6.1
echo dir=$1/GOPS_Framework/
echo project=GOPS.xcodeproj

target=libGOPS
target2=GOPS_SDK
configuration=Distribution
configuration2=Release
sdk=iphoneos6.1
sdk2=iphonesimulator6.1
sdk3=iphonesimulator6.1
dir=$1/GOPS_Framework/
momd=$dir/build/Framework/GOPS.framework/Versions/A/Resources/GOPS.momd/
sdkFolderMomd=$1/GOPS_SDK/GOPS.momd/
sdkFolderTC=$1/GOPS_TimeClock/GOPSTC/
gopsTC=$1/GOPS_TimeClock/GOPSTC/
project=GOPS.xcodeproj
dir2=$1/GOPS_SDK/
project2=GOPS_SDK.xcodeproj
keychain="ci_keys"
keychain_password="gops"
provisioning_profile="CBS Ent"
xcodePath = xcode-select -p --print-path

#echo "#Deleting Derived Data "
#rm -R /Users/kmacalino/Library/Developer/Xcode/DerivedData/*

sudo xcode-select -switch /Applications/Xcode4.app/Contents/Developer

echo $xcodePath

function validate_keychain()
{
# unlock the keychain containing the provisioning profile's private key and set it as the default keychain
security unlock-keychain -p "$keychain_password" "$HOME/Library/Keychains/$keychain.keychain"
security default-keychain -s "$HOME/Library/Keychains/$keychain.keychain"

#describe the available provisioning profiles
echo "Available provisioning profiles"
security find-identity -p codesigning -v

#verify that the requested provisioning profile can be found
(security find-certificate -a -c "$provisioning_profile" -Z | grep ^SHA-1) || failed provisioning_profile
}


function build_app()
{
echo "Clean Stuff"
xcodebuild -project ${dir}/${project} -alltargets clean

echo "#Real work is being done now"

echo "#Building Distribution Build with iphoneos6.1"
xcodebuild -project ${dir}/${project} -target "${target}" -configuration "$configuration" -sdk $sdk 

echo "#Building Release Build with iphonesimulator6.1"
xcodebuild -project ${dir}/${project} -target "${target}" -configuration "$configuration" -sdk $sdk2

echo "#BUILDING THE FRAMEWORK AGAIN BECAUSE IT IS AWESOME!"

echo "#Building Distribution Build with iphoneos6.1"
xcodebuild -project ${dir}/${project} -target "${target}" -configuration "$configuration" -sdk $sdk2 

echo "#Building Release Build with iphonesimulator6.1"
xcodebuild -project ${dir}/${project} -target "${target}" -configuration "$configuration" -sdk $sdk2 


echo #locate this project's DerivedData directory
local derived_data_path="$HOME/Library/Developer/Xcode/DerivedData/"
local project_derived_data_directory=$(ls $HOME/Library/Developer/Xcode/DerivedData | grep -e "GOPS-")
local project_derived_data_path="${derived_data_path}${project_derived_data_directory}"
local project_derived_data_directory2=$(ls $HOME/Library/Developer/Xcode/DerivedData | grep -e "GOPS_SDK-")
local project_derived_data_path2="${derived_data_path}${project_derived_data_directory2}"
echo #locate the .app file

project_app=$(ls -1 "${project_derived_data_path}/Build/Products/Distribution-iphoneos/" | grep -e GOPS.momd)

echo "ReLinking Resource Files in the build directory"

rm -rf $dir/build/Framework/GOPS.framework/Resources
rm -rf $dir/build/Framework/GOPS.framework/Headers

ln -s $dir/build/Framework/GOPS.framework/Versions/A/Resources/ $dir/build/Framework/GOPS.framework/Resources
ln -s $dir/build/Framework/GOPS.framework/Versions/A/Headers/ $dir/build/Framework/GOPS.framework/Headers

echo "#Copy Resource Files"

ditto $momd $sdkFolderMomd
ditto $gopsTC $sdkFolderTC

echo "project_app"
echo "#relink CodeResources, xcodebuild does not reliably construct the appropriate symlink"
rm unlink $project_app


echo ln -s $dir/build/Distribution-iphoneos/GOPS.momd $project_derived_data_path/Build/Products/Distribution-iphoneos/GOPS.momd

ln -s $dir/build/Distribution-iphoneos/GOPS.momd $project_derived_data_path/Build/Products/Distribution-iphoneos/GOPS.momd
ln -s $sdkFolderTC $gopsTC

echo "#modify date just to make sure it gets copied by xcodebuild"
touch -cm $sdkFolderTC
touch -cm $dir/build/Distribution-iphoneos/GOPS.momd

}


echo "******BUILDING FRAMEWORK HERE SON!!!"
build_app


function build_app2()
{
echo "******Clean SDK Stuff******"
xcodebuild -project ${dir2}${project2} -alltargets clean

echo #locate this project's DerivedData directory
local derived_data_path="$HOME/Library/Developer/Xcode/DerivedData/"
local project_derived_data_directory=$(ls $HOME/Library/Developer/Xcode/DerivedData | grep -e "GOPS-")
local project_derived_data_path="${derived_data_path}${project_derived_data_directory}"
local project_derived_data_directory2=$(ls $HOME/Library/Developer/Xcode/DerivedData | grep -e "GOPS_SDK-")
local project_derived_data_path2="${derived_data_path}${project_derived_data_directory2}"


project_app=$(ls -1 "${project_derived_data_path}/Build/Products/Distribution-iphoneos/" | grep -e GOPS.momd)

echo "project_app"
echo "#relink CodeResources, xcodebuild does not reliably construct the appropriate symlink"
rm unlink ${project_app}
ln -s "${dir}/build/Distribution-iphoneos/GOPS.momd" "${project_derived_data_path}/Build/Products/Distribution-iphoneos/GOPS.momd"
ln -s "${sdkFolderTC}" "${gopsTC}"

echo "#modify date just to make sure it gets copied by xcodebuild"
touch -cm ${sdkFolderTC}
touch -cm ${dir}/build/Distribution-iphoneos/GOPS.momd
touch -cm ${momd}

echo "Build GOPS_SDK Project"
xcodebuild -project ${dir2}${project2} -target ${target2} -sdk ${sdk} -configuration "${configuration}"

echo #locate the .app file

project_app=$(ls -1 "${dir2}build/Distribution-iphoneos/" | grep -e GOPS_SDK)
echo ${dir2}build/Distribution-iphoneos/$project_app
# if [ $(ls -1 "$project_derived_data_path/Build/Products/Release-iphoneos/$project_app" | wc -l) -ne 1 ]

if [[ -f ${dir2}build/Distribution-iphoneos/GOPS_SDK.app ]];
then
echo "Built $project_app in $project_derived_data_path"
else
echo "Failed to find a single .app build product."
echo "Failed to locate $project_derived_data_path/Build/Products/Distribution-iphoneos/$project_app"
#failed locate_built_product
fi

}

echo "******BUILDING APP HERE SON!!!"
build_app2

sudo xcode-select -r --reset

