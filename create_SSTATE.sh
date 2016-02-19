#!/bin/bash

usage()
{
  echo "Usage:$0 <BRANCH> <MACHINE>"
  exit 1
}
clone_it ()
{
    mkdir -p $BRANCH
    ls -al $BRANCH

}


if [ "$1" = ""  ]; then
    usage;
else
    BRANCH=$1;
fi

if [ "$2" = ""  ]; then
    usage;
else
    MACHINE=$2;
fi

echo "BRANCH=$BRANCH"


clone_it
