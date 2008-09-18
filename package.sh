#!/bin/bash

if [ $# != 2 ]
then
   echo "Usage: package.sh [linux|windows] [kit path]"
   exit 0
fi

if [ $1 == "linux" ]
then
   tar cjvf $2.tar.bz2 $2
else
   zip -r $2.zip $2
fi
