#!/bin/bash

TOPDIR=`pwd`
DOWNLOADS="$TOPDIR/DL_DIR"
LOGFILE="create_SSTATE.log"
usage()
{
  echo "Usage:$0 <BRANCH> <MACHINE> TARGETS"
  exit 1
}

POKY="http://git.yoctoproject.org/git/poky"



clone_it ()
{
    DEPTH=1
    Q="--quiet"
    mkdir -p $TOPDIR/SRC/$BRANCH
    cd $TOPDIR/SRC/$BRANCH
    if [ ! -d poky ]; then
	echo "Cloning $BRANCH"
	git clone ${Q} --depth=${DEPTH} $POKY
	cd poky
    else
	echo "Fetching $BRANCH"
	cd poky
	git fetch --all --depth=${DEPTH} ${Q}
    fi
    git reset --hard HEAD ${Q}
    git checkout ${Q} origin/$BRANCH
    git branch -D ${Q} $BRANCH
    git checkout ${Q} -b $BRANCH origin/$BRANCH
    echo "Cleaning $BRANCH"
    git clean ${Q} -fdx
}

build_it ()
{
    cd $TOPDIR/SRC/$BRANCH
    rm -rf build
    source ./poky/oe-init-build-env >> /dev/null
    echo ' I am in ' `pwd`
    echo "DL_DIR=\"$DOWNLOADS\" ">> conf/local.conf
    echo "MACHINE=\"$MACHINE\" ">> conf/local.conf
    echo "SSTATE_DIR=\"$TOPDIR/SRC/$BRANCH/sstate-cache\" ">> conf/local.conf
    for t in $TARGETS; do
	echo "ME BUILD $t"
	bitbake $t
    done

}

if [ "$1" = ""  ]; then
    usage;
else
    BRANCH=$1;
fi
shift
if [ "$1" = ""  ]; then
    usage;
else
    MACHINE=$1;
fi
shift
TARGETS=$*
if [ "$TARGETS" = ""  ]; then
    usage;
fi

echo "BRANCH=$BRANCH"
echo "MACHINE=$MACHINE"
echo "TARGETS=$TARGETS"

clone_it
build_it
