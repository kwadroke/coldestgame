#!/bin/bash

if [ $# != 1 -a $# != 2 ]
then
   echo "Usage: $0 <linux|windows> [nofull]"
   exit 0
fi

REVISION=`svn info | grep Revision | cut -f 2 -d \ `

arch=`uname -m`

if [ $1 == "linux" ]
then
   path=/var/www/files/updates/linux/$arch
   filename=Coldest$REVISION*.tar.bz2
else
   path=/var/www/files/updates/windows/32bit
   filename=Coldest$REVISION*.zip
fi

rsync -avz -e ssh Coldest$REVISION/* coldestgame.com:$path

if [[ $# != 2 || $2 != "nofull" ]]
then
   echo "Uploading full build"
   rsync -avz -e ssh $filename coldestgame.com:/var/www/files
fi

ssh coldestgame.com "cd $path && /usr/local/sbin/gencrcfile"


