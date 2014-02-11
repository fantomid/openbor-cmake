# Locate Vorbis
# This module defines
# OGG_LIBRARY
# OGG_FOUND, if false, do not try to link to Vorbis 
# OGG_INCLUDE_DIR, where to find the headers
#
# Created by fantomid (Guillaume Gasnier). Based on FindVorbis.cmake module.
#

FIND_PATH(OGG_INCLUDE_DIR
	NAMES ogg.h
	PATH_SUFFIXES ogg)

FIND_LIBRARY(OGG_LIBRARY 
	ogg)

SET(OGG_FOUND "NO")
IF(OGG_LIBRARY AND OGG_INCLUDE_DIR)
	SET(OGG_FOUND "YES")
ENDIF(OGG_LIBRARY AND OGG_INCLUDE_DIR)

if(${OGG_FOUND} MATCHES "NO")
	MESSAGE("-- Ogg not found")
else()
	MESSAGE("-- Found Ogg: ${OGG_LIBRARY}")
endif()
