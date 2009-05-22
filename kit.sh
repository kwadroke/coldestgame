#!/bin/bash

if [ $# != 1 ]
then
   echo "Usage: $0 [new kit path]"
   exit 0
fi

mkdir -p $1

cp -r fonts items lib maps materials models particles shaders textures weapons units sounds gpl.txt $1
cp coldest $1/coldest.bin
cp startscript $1/coldest
mkdir $1/gui
cp gui/*.xml $1/gui

find $1 | grep \.svn | xargs rm -rf
find $1 | grep \~ | xargs rm
find $1 | grep \.obj | xargs rm
find $1 | grep \.xcf | xargs rm
find $1 | grep \.blend | xargs rm
find $1 | grep \.tga | xargs rm