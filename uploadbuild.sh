#!/bin/bash

if [ $# != 1 -a $# != 2 ]
then
   echo "Usage: $0 <linux|windows> [nofull]"
   exit 0
fi

REVISION=`git log --pretty=oneline | wc -l`

arch=`uname -m`

if [ $1 == "linux" ]
then
   path=/var/www/files/updates/linux/$arch
   filename=Coldest$REVISION*.tar.bz2
else
   path=/var/www/files/updates/windows/32bit
   filename=Coldest$REVISION*.zip
fi

rsync -avz -e ssh --delete Coldest$REVISION/* coldestgame.com:$path

if [[ $# != 2 || $2 != "nofull" ]]
then
   echo "Uploading full build"
   #rsync -avz -e ssh $filename coldestgame.com:/var/www/files
   rsync -avz -e ssh $filename cybertronix,coldestgame@frs.sourceforge.net:/home/frs/project/c/co/coldestgame/
fi

ssh coldestgame.com "cd $path && /usr/local/sbin/gencrcfile"


