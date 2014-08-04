#!/bin/bash

branch=$(basename $2)

case $branch in
master)
    PRODUCT_NAME="Order Entry"
    ;;
develop)
    PRODUCT_NAME="Develop Line"
    ;;
release-*)
    ver=$( echo $branch | sed 's/release-//' )
    PRODUCT_NAME="Order Entry $ver"
    ;;
*)
    PRODUCT_NAME="$(basename $2)"
    ;;
esac

echo PRODUCT_NAME=$PRODUCT_NAME

# Make sure we're on Xcode 5
echo gops | sudo -S xcode-select -r --reset

# Build
cd ../..
rake build PRODUCT_NAME="$PRODUCT_NAME"

# Move the app into the place the build server expects it

mkdir -p GOPS_SDK/build/Distribution-iphoneos
mv "build/Products/$PRODUCT_NAME.app"      "GOPS_SDK/build/Distribution-iphoneos/GOPS_SDK.app"


