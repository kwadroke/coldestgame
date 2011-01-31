# Locate ALUT
# This module defines
# ALUT_LIBRARIES
# ALUT_FOUND, if false, do not try to link to ALUT 
# ALUT_INCLUDE_DIRS, where to find the headers
#
# $ALUTDIR is an environment variable that would
# correspond to the ./configure --prefix=$ALUTDIR
# used in building ALUT.
#
# Created by Sukender (Benoit Neil). Based on FindOpenAL.cmake module.

FIND_PATH(ALUT_INCLUDE_DIRS alut.h
	HINTS
	$ENV{ALUTDIR}
	$ENV{ALUT_PATH}	
	$ENV{CSP_DEVPACK}
	PATH_SUFFIXES include/AL include
	PATHS
	~/Library/Frameworks
	/Library/Frameworks
	/usr/local
	/usr
	/sw # Fink
	/opt/local # DarwinPorts
	/opt/csw # Blastwave
	/opt
)

FIND_LIBRARY(ALUT_LIBRARIES 
	alut
	HINTS
	$ENV{CSP_DEVPACK}
	$ENV{ALUTDIR}
	$ENV{ALUT_PATH}
	PATH_SUFFIXES lib64 lib libs64 libs libs/Win32 libs/Win64
	PATHS
	~/Library/Frameworks
	/Library/Frameworks
	/usr/local
	/usr
	/sw
	/opt/local
	/opt/csw
	/opt
)

FIND_LIBRARY(ALUT_LIBRARIES_DEBUG 
	alutd
	HINTS
	$ENV{CSP_DEVPACK}
	$ENV{ALUTDIR}
	$ENV{ALUT_PATH}
	PATH_SUFFIXES lib64 lib libs64 libs libs/Win32 libs/Win64
	PATHS
	~/Library/Frameworks
	/Library/Frameworks
	/usr/local
	/usr
	/sw
	/opt/local
	/opt/csw
	/opt
)

SET(ALUT_FOUND "NO")
IF(ALUT_LIBRARIES AND ALUT_INCLUDE_DIRS)
	SET(ALUT_FOUND "YES")
ENDIF(ALUT_LIBRARIES AND ALUT_INCLUDE_DIRS)
