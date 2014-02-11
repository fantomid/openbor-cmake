cmake_minimum_required(VERSION 2.8.8)
project(OpenBOR)

# Initialize modules path
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/modules/" ${CMAKE_MODULE_PATH})

option(TARGET_PANDORA "Build OpenBOR for Pandora handheld console" OFF)

set(BUILD_LINUX "NO")
set(BUILD_WIN "NO")
set(BUILD_SDL "NO")
set(BUILD_GFX "NO")
set(BUILD_PTHREAD "NO")
set(BUILD_SDL_IO "NO")
set(BUILD_OPENGL "NO")
set(BUILD_LOADGL "NO")
set(BUILD_VORBIS "NO")
set(BUILD_TREMOR "NO")

if(TARGET_PANDORA)
   set(BUILD_LINUX "YES")
   set(BUILD_SDL "YES")
   set(BUILD_GFX "YES")
   set(BUILD_PTHREAD "YES")
   set(BUILD_SDL_IO "YES")
   set(BUILD_TREMOR "YES")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux" AND UNIX)
   set(BUILD_LINUX "YES")
   set(BUILD_SDL "YES")
   set(BUILD_GFX "YES")
   set(BUILD_PTHREAD "YES")
   set(BUILD_SDL_IO "YES")
   set(BUILD_OPENGL "YES")
   set(BUILD_LOADGL "YES")
   set(BUILD_VORBIS "YES")
elseif(MINGW OR MSYS)
   set(BUILD_WIN "YES")
   set(BUILD_SDL "YES")
   set(BUILD_GFX "YES")
   set(BUILD_PTHREAD "YES")
   set(BUILD_SDL_IO "YES")
   set(BUILD_OPENGL "YES")
   set(BUILD_LOADGL "YES")
   set(BUILD_VORBIS "YES")
else()
   message(FATAL_ERROR "Target platform is not supported by CMake tool. Your system name is (${CMAKE_SYSTEM_NAME})")
endif()

if(BUILD_VORBIS MATCHES "YES" OR BUILD_TREMOR MATCHES "YES")
   if(BUILD_VORBIS MATCHES "YES")
      find_package(Ogg)
      find_package(Vorbis)
      find_package(VorbisFile)
   else()
      find_package(Ogg)
      find_package(Vorbisidec)
   endif()
#if(${VORBIS_FOUND} MATCHES "NO")
#endif()
#if(${VORBISFILE_FOUND} MATCHES "NO")
#endif()   
endif()

find_package(PNG)
if(${PNG_FOUND} MATCHES "NO")
   message(FATAL_ERROR "PNG is required and was not found !!!")
endif()

if(BUILD_SDL MATCHES "YES")
   find_package(SDL)
   find_package(SDL2)

   if(${SDL_FOUND} MATCHES "NO")
      message(FATAL_ERROR "SDL is required and was not found !!!")
   endif()
endif()

message("VORBIS ${VORBIS_FOUND} VORBISFILE ${VORBISFILE_FOUND} PNG ${PNG_FOUND} SDL ${SDL_FOUND}")

MESSAGE("System name: ${CMAKE_SYSTEM_NAME}")
MESSAGE("Build LINUX: ${BUILD_LINUX}")
MESSAGE("Build SDL: ${BUILD_SDL}")
MESSAGE("Build GFX: ${BUILD_GFX}")
MESSAGE("Build PTHREAD: ${BUILD_PTHREAD}")
MESSAGE("Build SDL_IO: ${BUILD_SDL_IO}")
MESSAGE("Build OPENGL: ${BUILD_OPENGL}")
MESSAGE("Build LOADGL: ${BUILD_LOADGL}")
MESSAGE("Build VORBIS: ${BUILD_VORBIS}")
MESSAGE("Build TREMOR: ${BUILD_TREMOR}")

if(SDL_FOUND AND BUILD_SDL MATCHES "YES")
   include_directories(sdl)
   include_directories(${SDL_INCLUDE_DIR})
endif()

if(SDL_FOUND AND BUILD_SDL_IO MATCHES "YES")
   set(OpenBOR_GAME_CONSOLE_SRCS
      sdl/joysticks.c
      sdl/control.c
      sdl/sblaster.c
      sdl/timer.c
      sdl/sdlport.c
      sdl/video.c
      sdl/menu.c)

   set(OpenBOR_GAME_CONSOLE_HEADERS
      sdl/joysticks.h
      sdl/control.h
      sdl/sblaster.h
      sdl/timer.h
      sdl/sdlport.h
      sdl/video.h
      sdl/menu.h)
endif()


if(SDL_FOUND AND BUILD_OPENGL MATCHES "YES")
   set(OpenBOR_GAME_CONSOLE_SRCS ${OpenBOR_GAME_CONSOLE_SRCS}
      sdl/opengl.c)

   set(OpenBOR_GAME_CONSOLE_HEADERS ${OpenBOR_GAME_CONSOLE_HEADERS}
      sdl/opengl.h)
endif()


if(SDL_FOUND AND BUILD_LOADGL MATCHES "YES")
   set(OpenBOR_GAME_CONSOLE_SRCS ${OpenBOR_GAME_CONSOLE_SRCS}
      sdl/loadgl.c)

   set(OpenBOR_GAME_CONSOLE_HEADERS ${OpenBOR_GAME_CONSOLE_HEADERS}
      sdl/loadgl.h)
endif()

if(SDL2_FOUND MATCHES "YES" AND NOT SDL_FOUND)
   include_directories(sdl)
   include_directories(${SDL2_INCLUDE_DIR})
endif()

set(OpenBOR_SRCS
   openbor.c
   openborscript.c)

set(OpenBOR_HEADERS
   openbor.h
   openborscript.h)

include_directories(.)

set(OpenBOR_SOURCE_SRCS
   source/stringptr.c
   source/utils.c
   source/stristr.c)

set(OpenBOR_SOURCE_HEADERS
   source/stringptr.h
   source/stristr.h
   source/utils.h)

include_directories(source)

set(OpenBOR_ADPCM_SRCS
   source/adpcmlib/adpcm.c)

set(OpenBOR_ADPCM_HEADERS
   source/adpcmlib/adpcm.h)

include_directories(source/adpcmlib)

set(OpenBOR_GAME_SRCS
   source/gamelib/draw.c
   source/gamelib/draw16.c
   source/gamelib/draw32.c
   source/gamelib/font.c)

if(EXISTS "${CMAKE_SOURCE_DIR}/source/gamelib/translation.c")
   set(OpenBOR_GAME_SRCS ${OpenBOR_GAME_SRCS}
      source/gamelib/translation.c)
endif()

set(OpenBOR_GAME_SRCS ${OpenBOR_GAME_SRCS}
   source/gamelib/anigif.c
   source/gamelib/bitmap.c
   source/gamelib/screen.c
   source/gamelib/screen16.c
   source/gamelib/screen32.c
   source/gamelib/loadimg.c
   source/gamelib/palette.c
   source/gamelib/packfile.c
   source/gamelib/filecache.c
   source/gamelib/pixelformat.c
   source/gamelib/soundmix.c
   source/gamelib/spriteq.c
   source/gamelib/sprite.c
   source/gamelib/spritex8p16.c
   source/gamelib/spritex8p32.c
   source/gamelib/commands.c
   source/gamelib/models.c
   source/gamelib/transform.c)

if(EXISTS "${CMAKE_SOURCE_DIR}/source/gamelib/triangle.c")
   set(OpenBOR_GAME_SRCS ${OpenBOR_GAME_SRCS}
      source/gamelib/triangle.c)
endif()

set(OpenBOR_GAME_HEADERS
   source/gamelib/draw.h
   source/gamelib/draw16.h
   source/gamelib/draw32.h
   source/gamelib/font.h)

if(EXISTS "${CMAKE_SOURCE_DIR}/source/gamelib/translation.h")
   set(OpenBOR_GAME_HEADERS ${OpenBOR_GAME_HEADERS}
      source/gamelib/translation.h)
endif()

set(OpenBOR_GAME_HEADERS
   ${OpenBOR_GAME_HEADERS}
   source/gamelib/anigif.h
   source/gamelib/bitmap.h
   source/gamelib/screen.h
   source/gamelib/screen16.h
   source/gamelib/screen32.h
   source/gamelib/loadimg.h
   source/gamelib/palette.h
   source/gamelib/packfile.h
   source/gamelib/filecache.h
   source/gamelib/pixelformat.h
   source/gamelib/soundmix.h
   source/gamelib/spriteq.h
   source/gamelib/sprite.h
   source/gamelib/spritex8p16.h
   source/gamelib/spritex8p32.h
   source/gamelib/commands.h
   source/gamelib/models.h
   source/gamelib/transform.h)

if(EXISTS "${CMAKE_SOURCE_DIR}/source/gamelib/triangle.h")
   set(OpenBOR_GAME_HEADERS ${OpenBOR_GAME_HEADERS}
      source/gamelib/triangle.h)
endif()

if(SDL_FOUND AND BUILD_SDL MATCHES "YES")
   set(OpenBOR_GAME_SRCS ${OpenBOR_GAME_SRCS} 
      source/gamelib/filters.c)
   set(OpenBOR_GAME_HEADERS ${OpenBOR_GAME_HEADERS}
      source/gamelib/filters.h)
endif()

include_directories(source/gamelib)

if(CPU_MMX_EXTENSION)
   set(OpenBOR_GFX_SRCS ${OpenBOR_GFX_SRCS}
      source/gfxlib/2xSaImmx.c
      source/gfxlib/bilinearmmx.c
      source/gfxlib/hq2x16mmx.c)

   set(OpenBOR_GFX_HEADERS ${OpenBOR_GFX_HEADERS}
      source/gfxlib/2xSaImmx.h
      source/gfxlib/bilinearmmx.h
      source/gfxlib/hq2x16mmx.h)
endif()

if(BUILD_GFX MATCHES "YES")
   set(OpenBOR_GFX_SRCS
      source/gfxlib/2xSaI.c
      source/gfxlib/bilinear.c
      source/gfxlib/dotmatrix.c
      source/gfxlib/gfx.c
      source/gfxlib/hq2x.c
      source/gfxlib/scale2x.c
      source/gfxlib/scanline.c
      source/gfxlib/simple2x.c
      source/gfxlib/tv2x.c)

   set(OpenBOR_GFX_HEADERS
      source/gfxlib/2xSaI.h
      source/gfxlib/bilinear.h
      source/gfxlib/dotmatrix.h
      source/gfxlib/gfx.h
      source/gfxlib/hq2x.h
      source/gfxlib/scale2x.h
      source/gfxlib/scanline.h
      source/gfxlib/simple2x.h
      source/gfxlib/tv2x.h)
   
   include_directories(source/gfxlib)
endif()

set(OpenBOR_PNG_SRCS
   source/pnglib/pngdec.c
   source/pnglib/savepng.c)

set(OpenBOR_PNG_HEADERS
   source/pnglib/pngdec.h
   source/pnglib/savepng.h)

include_directories(source/pnglib)

set(OpenBOR_PREPROCESSOR_SRCS
   source/preprocessorlib/pp_lexer.c
   source/preprocessorlib/pp_parser.c)

if(EXISTS "${CMAKE_SOURCE_DIR}/source/preprocessorlib/pp_expr.c")
   set(OpenBOR_PREPROCESSOR_SRCS
      ${OpenBOR_PREPROCESSOR_SRCS}
      source/preprocessorlib/pp_expr.c)
endif()

set(OpenBOR_PREPROCESSOR_HEADERS
   source/preprocessorlib/pp_lexer.h
   source/preprocessorlib/pp_parser.h)

if(EXISTS "${CMAKE_SOURCE_DIR}/source/preprocessorlib/pp_expr.h")
   set(OpenBOR_PREPROCESSOR_HEADERS
      ${OpenBOR_PREPROCESSOR_HEADERS}
      source/preprocessorlib/pp_expr.h)
endif()

include_directories(source/preprocessorlib)

set(OpenBOR_RAM_SRCS
   source/ramlib/ram.c)

set(OpenBOR_RAM_HEADERS
   source/ramlib/ram.h)

include_directories(source/ramlib)

set(OpenBOR_RAND_SRCS
   source/randlib/rand32.c)

set(OpenBOR_RAND_HEADERS
   source/randlib/rand32.h)

include_directories(source/randlib)

set(OpenBOR_SCRIPT_SRCS
   source/scriptlib/StackedSymbolTable.c
   source/scriptlib/ScriptVariant.c
   source/scriptlib/SymbolTable.c
   source/scriptlib/Instruction.c
   source/scriptlib/Interpreter.c
   source/scriptlib/ImportCache.c
   source/scriptlib/ParserSet.c
   source/scriptlib/Parser.c
   source/scriptlib/Lexer.c
   source/scriptlib/Stack.c
   source/scriptlib/List.c)

set(OpenBOR_SCRIPT_HEADERS
   source/scriptlib/StackedSymbolTable.h
   source/scriptlib/ScriptVariant.h
   source/scriptlib/SymbolTable.h
   source/scriptlib/Instruction.h
   source/scriptlib/Interpreter.h
   source/scriptlib/ImportCache.h
   source/scriptlib/ParserSet.h
   source/scriptlib/Parser.h
   source/scriptlib/Lexer.h
   source/scriptlib/Stack.h
   source/scriptlib/List.h)

include_directories(source/scriptlib)

set(OpenBOR_CFLAGS_BASE "-g -Wall -Werror -fsigned-char")
if(BUILD_LINUX MATCHES "YES")
   set(OpenBOR_CFLAGS_PLATFORM "-Wno-unused-result -DLINUX")
endif()
if(BUILD_WIN MATCHES "YES")
   set(OpenBOR_CFLAGS_PLATFORM "-Wno-unused-result -DWIN")
endif()
if(SDL_FOUND AND BUILD_SDL MATCHES "YES")
   set(OpenBOR_CFLAGS_PLATFORM "${OpenBOR_CFLAGS_PLATFORM} -DSDL")
endif()

if(BUILD_MMX MATCHES "YES")
   set(OpenBOR_CFLAGS_PLATFORM "${OpenBOR_CFLAGS_PLATFORM} -DMMX")
endif()

if(BUILD_VORBIS MATCHES "YES")
   set(OpenBOR_CFLAGS_PLATFORM "${OpenBOR_CFLAGS_PLATFORM} -DOV_EXCLUDE_STATIC_CALLBACKS")
endif()

if(BUILD_TREMOR MATCHES "YES")
   set(OpenBOR_CFLAGS_PLATFORM "${OpenBOR_CFLAGS_PLATFORM} -DTREMOR")
endif()

if(BUILD_OPENGL MATCHES "YES")
   set(OpenBOR_CFLAGS_PLATFORM "${OpenBOR_CFLAGS_PLATFORM} -DOPENGL")
endif()

if(BUILD_LOADGL MATCHES "YES")
   set(OpenBOR_CFLAGS_PLATFORM "${OpenBOR_CFLAGS_PLATFORM} -DLOADGL")
endif()
add_executable(OpenBOR 
   ${OpenBOR_SRCS} 
   ${OpenBOR_SOURCE_SRCS} 
   ${OpenBOR_ADPCM_SRCS} 
   ${OpenBOR_GAME_SRCS}
   ${OpenBOR_GAME_CONSOLE_SRCS}
   ${OpenBOR_GFX_SRCS}
   ${OpenBOR_PNG_SRCS}
   ${OpenBOR_PREPROCESSOR_SRCS}
   ${OpenBOR_RAM_SRCS}
   ${OpenBOR_RAND_SRCS}
   ${OpenBOR_SCRIPT_SRCS}
   ${OpenBOR_SDL_SRCS})

target_link_libraries(OpenBOR png)
target_link_libraries(OpenBOR z)
target_link_libraries(OpenBOR m)

if(BUILD_VORBIS MATCHES "YES")
   target_link_libraries(OpenBOR vorbis)
   target_link_libraries(OpenBOR vorbisfile)
   target_link_libraries(OpenBOR ogg)
endif()
if(BUILD_PTHREAD MATCHES "YES")
   target_link_libraries(OpenBOR pthread)
endif()
if(BUILD_TREMOR MATCHES "YES")
   target_link_libraries(OpenBOR vorbisidec)
   target_link_libraries(OpenBOR ogg)   
endif()
if(SDL_FOUND AND BUILD_SDL MATCHES "YES")
   target_link_libraries(OpenBOR SDL)
   target_link_libraries(OpenBOR SDL_gfx)
endif()
if(BUILD_WIN MATCHES "YES")
   if(SDL_FOUND)
      target_link_libraries(OpenBOR SDLmain)
   endif()
   target_link_libraries(OpenBOR mingw32)
   target_link_libraries(OpenBOR Psapi)
   target_link_libraries(OpenBOR Kernel32)
endif()
set(OpenBOR_CFLAGS "${OpenBOR_CFLAGS_BASE} ${OpenBOR_CFLAGS_PLATFORM}")
set_target_properties(OpenBOR PROPERTIES COMPILE_FLAGS ${OpenBOR_CFLAGS})



