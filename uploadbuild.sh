#!/bin/bash
 
REVISION=`svn info | grep Revision | cut -f 2 -d \ `

arch=`uname -m`

ssh coldestgame.com "rm -rf /var/www/files/updates/linux/$arch/*"

scp -r Coldest$REVISION/* coldestgame.com:/var/www/files/updates/linux/$arch

ssh coldestgame.com "cd /var/www/files/updates/linux/$arch && /usr/local/sbin/gencrcfile"


