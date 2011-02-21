# Locate Xerces-c
# This module defines
# XercesC_LIBRARIES
# XercesC_FOUND, if false, do not try to link to xerces-c 
# XercesC_INCLUDE_DIRS, where to find the headers
#
# $XERCES_DIR is an environment variable that would
# correspond to the ./configure --prefix=$XERCES_DIR
#
# Created by Robert Osfield. 

FIND_PATH(XercesC_INCLUDE_DIRS xercesc
    ${XERCES_DIR}/include
    $ENV{XERCES_DIR}/include
    $ENV{XERCES_DIR}
    ${DELTA3D_EXT_DIR}/inc
    $ENV{CSPDEVPACK}/include
    $ENV{DELTA_ROOT}/ext/inc
    $ENV{DELTA_ROOT}
    $ENV{OSG_ROOT}/include
    ~/Library/Frameworks/Xerces.framework/Headers
    /Library/Frameworks/Xerces.framework/Headers
    /usr/local/include
    /usr/include
    /sw/include # Fink
    /opt/local/include # DarwinPorts
    /opt/csw/include # Blastwave
    /opt/include
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSG_ROOT]/include
    /usr/freeware/include
)

MACRO(FIND_XercesC_LIBRARIES MYLIBRARY MYLIBRARYNAME)

FIND_LIBRARY(${MYLIBRARY}
    NAMES ${MYLIBRARYNAME} 
    PATHS
    ${XERCES_DIR}/lib
    $ENV{XERCES_DIR}/lib
    $ENV{XERCES_DIR}
    ${DELTA3D_EXT_DIR}/lib
    $ENV{DELTA_ROOT}/ext/lib
    $ENV{DELTA_ROOT}
    $ENV{OSG_ROOT}/lib
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local/lib
    /usr/lib
    /sw/lib
    /opt/local/lib
    /opt/csw/lib
    /opt/lib
    [HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session\ Manager\\Environment;OSG_ROOT]/lib
    /usr/freeware/lib64
)

ENDMACRO(FIND_XercesC_LIBRARIES MYLIBRARY MYLIBRARYNAME)

SET(XERCES_LIST Xerces xerces-c xerces-c_2 xerces-c_3)
FIND_XercesC_LIBRARIES(XercesC_LIBRARIES "${XERCES_LIST}")
SET(XERCES_DEBUG_LIST Xerces xerces-c_2d xerces-c_3D)
FIND_XercesC_LIBRARIES(XercesC_LIBRARIES_DEBUG "${XERCES_DEBUG_LIST}")

SET(XercesC_FOUND "NO")
IF(XercesC_LIBRARIES AND XercesC_INCLUDE_DIRS)
	SET(XercesC_FOUND ${XercesC_FOUND})
ENDIF(XercesC_LIBRARIES AND XercesC_INCLUDE_DIRS)


