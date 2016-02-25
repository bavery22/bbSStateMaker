#!/bin/sh


STARTTIME=$(date +%s)

time ./create_SSTATE.sh master qemux86-64 core-image-minimal core-image-sato ;
time ./create_SSTATE.sh master qemux86 core-image-minimal core-image-sato;
echo "Copying to Staging Area"
rsync -a SRC/master/sstate-cache/ OUT/master/sstate-cache/;
echo "Copying to Remote"
rsync -a OUT/ bavery@downloads.yoctoproject.org:/sstate-test/;
ENDTIME=$(date +%s)
DELTATIME=$(($ENDTIME - $STARTTIME))
echo "It takes $DELTATIME seconds to complete this task..."
#if [ $DELTATIME -gt 3600 ]; then
#    SLEEPTIME=$((3600 - $DELTATIME))
#    echo "sleeping for $SLEEPTIME secs..."
#    sleep $SLEEPTIME
#fi
