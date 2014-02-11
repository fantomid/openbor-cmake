# Locate SDL2
# This module defines
# SDL2_LIBRARY
# SDL2_FOUND, if false, do not try to link to Vorbis 
# SDL2_INCLUDE_DIR, where to find the headers
#
# Created by fantomid (Guillaume Gasnier). Based on FindVorbis.cmake module.
#

FIND_PATH(SDL2_INCLUDE_DIR
	NAMES SDL_scancode.h
	PATH_SUFFIXES SDL2)

FIND_LIBRARY(SDL2_LIBRARY 
	SDL2)

SET(SDL2_FOUND "NO")
IF(SDL2_LIBRARY AND SDL2_INCLUDE_DIR)
	SET(SDL2_FOUND "YES")
ENDIF(SDL2_LIBRARY AND SDL2_INCLUDE_DIR)

if(${SDL2_FOUND} MATCHES "NO")
	MESSAGE("-- SDL2 not found")
else()
	MESSAGE("-- Found SDL2: ${SDL2_LIBRARY}")
endif()