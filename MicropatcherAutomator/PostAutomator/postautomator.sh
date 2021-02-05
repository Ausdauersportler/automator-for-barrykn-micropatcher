#!/bin/sh

#  postautomator.sh
#
#
#  Created by Nathan Taylor on 11/26/20.
#  Edited by Ausdauersportler on 01/21/21
#  added compability with micropatcher dev-v0.5.4 and later
#
#Drives
VOLUME=$1
echo $VOLUME
MODEL=$(sysctl -n hw.model)
#Model,OSVER
OSVER=$(defaults read /Volumes/"$VOLUME"/System/Library/CoreServices/SystemVersion ProductVersion)
Model=$(sysctl hw.model)
ModelIdentifier=$(echo $Model)
ReadModel=$(sysctl -n hw.model)
echo $ReadModelr running $OSVER detected!
INSTALLER=$(dirname "$0")
# does not work in recovery mode, dirname: command not found
# chroot to "/Volumes/$VOLUME" will work, this is the complete Bit Sur installation and so one will find the dirname command there
if [ -d "/Volumes/Image Volume" ]; then
    echo '[Out] Recovery mode detected!'
    INSTALLER=/Volumes/Image\ Volume
fi
echo "$INSTALLER"

# only case no included in the patch-kext.sh
case $MODEL in
#        MacPro3,[1-3])
#        PATCHMODE=--2010
#        ;;
        iMac11,[1-3] | iMac12,[1-2])
#        PATCHMODE=--ns
        OPENCORE=YES
        ;;
        MacBookPro6,?)
        OPENCORE=YES
        ;;
esac

#the actual patching process

echo "[Out] If you have a non metal GPU, please downgrade to an older OS."
echo "Assuming you have a Metal compatible GPU, you will have acceleration."
sleep 5
"$INSTALLER/patch-kexts.sh" $PATCHMODE "/Volumes/$VOLUME"

if [ "x$OPENCORE" = "xYES" ]
then
    echo "[Out] Finished Patching! Starting configuration of opencore..."
    "$INSTALLER"/config-opencore.sh --volume /Volumes/"$VOLUME" "$INSTALLER"
    echo "[Out] Finished configuration of opencore! You may now restart..."
    exit
else
    echo "[Out] Finished Patching! You may now restart..."
    exit
fi

echo "If you can read this, that means that I probably broke something and the patching process has failed because your Mac model could not be determined. Please report this issue on GitHub along with your model of Mac. Sorry for the inconvenience!"

echo "[Error] Error! Check verbose output for more info"

exit


