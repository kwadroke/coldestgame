#!/bin/bash
 
REVISION=`svn info | grep Revision | cut -f 2 -d \ `

arch=`uname -m`

rsync -avz -e ssh Coldest$REVISION/* coldestgame.com:/var/www/files/updates/linux/$arch

rsync -avz -e ssh Coldest$REVISION*.tar.bz2 coldestgame.com:/var/www/files

ssh coldestgame.com "cd /var/www/files/updates/linux/$arch && /usr/local/sbin/gencrcfile"


