#!/bin/bash

TOPDIR=`pwd`
DOWNLOADS="/big/DL_DIR"
usage()
{
  echo "Usage:$0 <BRANCH> <MACHINE> TARGETS"
  exit 1
}

POKY="http://git.yoctoproject.org/git/poky"



clone_it ()
{

    mkdir -p $TOPDIR/SRC/$BRANCH
    cd $TOPDIR/SRC/$BRANCH
    if [ ! -d poky ]; then
	git clone $POKY
    fi
    cd poky
    git fetch --all
    git reset --hard HEAD
    git checkout origin/$BRANCH
    git branch -D $BRANCH
    git checkout -b $BRANCH origin/$BRANCH
    git clean -fdx
}

build_it ()
{
    cd $TOPDIR/SRC/$BRANCH
    rm -rf build
    source ./poky/oe-init-build-env
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
