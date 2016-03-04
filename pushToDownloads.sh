#!/bin/sh


STARTTIME=$(date +%s)
BRANCHES="master"
MACHINES="qemux86-64 qemux86"
IMAGES="core-image-minimal core-image-sato"
for BRANCH in $BRANCHES; do
    for MACHINE in $MACHINES; do
	for IMAGE in $IMAGES; do
	    echo "Working on $BRANCH for $MACHINE and $IMAGE image"
	    time ./create_SSTATE.sh ${BRANCH} ${MACHINE} ${IMAGE} ;
	    echo "Cleaning Staging area of files more than 2 days old."
	    NUM_FILES_REMOVED=`find SRC/${BRANCH}/sstate-cache/ -mtime +2 | wc -l `
	    echo "Cleaning ${NUM_FILES_REMOVED} files"
	    find SRC/${BRANCH}/sstate-cache/ -mtime +2 -exec rm -rf {} \;
	    echo "Final Size: "`du -sh SRC/${BRANCH}/sstate-cache/`
	    echo "Copying to Staging Area"
	    mkdir -p OUT/${BRANCH}/sstate-cache/
	    rsync -a --delete SRC/${BRANCH}/sstate-cache/ OUT/${BRANCH}/sstate-cache/;
	    echo "Copying to Remote"
	    rsync -a --delete OUT/ bavery@downloads.yoctoproject.org:/sstate-test/;
	done
    done
done
	ENDTIME=$(date +%s)
	DELTATIME=$(($ENDTIME - $STARTTIME))
	DELTAMIN=$(($DELTATIME/60))
	echo "We did Branches=$BRANCHES"
	echo "We did Machines=$MACHINES"
	echo "We did Images=$IMAGES"
	echo "It took $DELTATIME seconds ($DELTAMIN minutes) to complete this task..."
#if [ $DELTATIME -gt 3600 ]; then
#    SLEEPTIME=$((3600 - $DELTATIME))
#    echo "sleeping for $SLEEPTIME secs..."
#    sleep $SLEEPTIME
#fi
