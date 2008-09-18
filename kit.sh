#!/bin/bash

if [ $# != 1 ]
then
   echo "Usage: $0 [new kit path]"
   exit 0
fi

mkdir -p $1

cp -r fonts items lib maps materials models particles shaders textures weapons $1
cp coldest $1/coldest.bin
cp startscript $1/coldest

find $1 | grep \.svn | xargs rm -rf
