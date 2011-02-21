# Locate Vorbis
# This module defines
# Vorbis_LIBRARIES
# Vorbis_FOUND, if false, do not try to link to Vorbis 
# Vorbis_INCLUDE_DIRS, where to find the headers
#
# $VORBISDIR is an environment variable that would
# correspond to the ./configure --prefix=$VORBISDIR
# used in building Vorbis.
#
# Created by Sukender (Benoit Neil). Based on FindOpenAL.cmake module.
# TODO Add hints for linux and Mac

FIND_PATH(Vorbis_INCLUDE_DIRS
	vorbis/codec.h
	HINTS
	$ENV{VORBISDIR}
    $ENV{CSP_DEVPACK}
	$ENV{Vorbis_PATH}
	PATH_SUFFIXES include
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

FIND_LIBRARY(Vorbis_LIBRARIES 
	vorbis
	HINTS
	$ENV{VORBISDIR}
    $ENV{CSP_DEVPACK}
	$ENV{Vorbis_PATH}
	PATH_SUFFIXES win32/Vorbis_Dynamic_Release
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

FIND_LIBRARY(Vorbis_LIBRARIES_DEBUG 
	Vorbis_d
	HINTS
	$ENV{VORBISDIR}
    $ENV{CSP_DEVPACK}
	$ENV{Vorbis_PATH}
	PATH_SUFFIXES win32/Vorbis_Dynamic_Debug
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


SET(Vorbis_FOUND "NO")
IF(Vorbis_LIBRARIES AND Vorbis_INCLUDE_DIRS)
	SET(Vorbis_FOUND "YES")
ENDIF(Vorbis_LIBRARIES AND Vorbis_INCLUDE_DIRS)

