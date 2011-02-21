project(Coldest CXX C)
cmake_minimum_required(VERSION 2.6)
cmake_policy(VERSION 2.6)
#TODO: Project version handling
set(PROJECT_VERSION "99999")
set(EXENAME coldest)

# Allow control over what to build
option(BUILD_CLIENT           "Build the main game."    ON)
option(BUILD_DEDICATED_SERVER "Build dedicated server." OFF)
option(BUILD_MASTER_SERVER    "Build master server."    OFF)

# Avoid source tree pollution
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
	message(FATAL_ERROR "In-source builds are not permitted. Make a separate folder for building:\nmkdir build; cd build; cmake ..\nBefore that, remove the files already created:\nrm -rf CMakeCache.txt CMakeFiles")
endif(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)

# Where are our modules stored
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")

# Add a sensible build type default and warning because empty means no optimization and no debug info
if(NOT CMAKE_BUILD_TYPE)
	message("WARNING: CMAKE_BUILD_TYPE is not defined!\n         Defaulting to CMAKE_BUILD_TYPE=RelWithDebInfo. Use ccmake to set a proper value.")
	set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# Set default compile flags for GCC
if(CMAKE_COMPILER_IS_GNUCXX)
	message(STATUS "GCC detected, adding compile flags")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wno-missing-field-initializers -Wno-deprecated")
	# -pthread is unrecognized on Windows and ansi standard causes errors
	if(NOT WIN32)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++98 -pthread")
	endif(NOT WIN32)
endif(CMAKE_COMPILER_IS_GNUCXX)


# Sources

file(GLOB GUI_SOURCES gui/*.cpp) # GUI is nicely in its own directory so let's GLOB it

set(COMMON_SOURCES
	coldest.cpp Vector3.cpp GraphicMatrix.cpp CollisionDetection.cpp
	Particle.cpp ProceduralTree.cpp TextureHandler.cpp Hit.cpp Vertex.cpp
	Console.cpp server.cpp IDGen.cpp Weapon.cpp Recorder.cpp Replayer.cpp
	ObjectKDTree.cpp TextureManager.cpp Packet.cpp VBO.cpp MeshData.cpp
	Timer.cpp ServerInfo.cpp getmap.cpp ParticleEmitter.cpp StableRandom.cpp
	renderdefs.cpp globals.cpp netdefs.cpp PlayerData.cpp Log.cpp logout.cpp
	NTreeReader.cpp Material.cpp ResourceManager.cpp Mesh.cpp Triangle.cpp
	Quad.cpp MeshNode.cpp ServerState.cpp MeshCache.cpp tsint.cpp Bot.cpp
	Item.cpp util.cpp Mutex.cpp
	)

set(CLIENT_SOURCES
	actions.cpp ALBuffer.cpp ALSource.cpp Camera.cpp editor.cpp FBO.cpp Light.cpp
	net.cpp render.cpp settings.cpp Shader.cpp SoundManager.cpp TextureHandler.cpp
	Updater.cpp
	)

set(DEDICATED_SERVER_SOURCES "") # Nothing apparantly

set(MASTER_SERVER_SOURCES
	master.cpp util.cpp Packet.cpp ServerInfo.cpp Vector3.cpp GraphicMatrix.cpp
	tsint.cpp logout.cpp Log.cpp IDGen.cpp
	)


# Libraries

# Boost
find_package(Boost 1.36 REQUIRED COMPONENTS filesystem)
include_directories(${Boost_INCLUDE_DIRS})
list(APPEND LIBS ${Boost_LIBRARIES})
list(APPEND CLIENTLIBS ${Boost_LIBRARIES})

set(FINDLIBS SDL SDL_image SDL_net SDL_ttf XercesC CURL)
# These aren't needed (and cause problems) for the dedicated server
set(FINDCLIENTLIBS GLEW OpenGL OpenAL ALUT OGG Vorbis VorbisFile)

# Find all the libs that don't require extra parameters
foreach(lib ${FINDLIBS})
	find_package(${lib} REQUIRED)
	include_directories(${${lib}_INCLUDE_DIRS})
	list(APPEND LIBS ${${lib}_LIBRARIES})
	list(APPEND CLIENTLIBS ${${lib}_LIBRARIES})
	add_definitions(${${lib}_DEFINITIONS})
	# Poor modules don't do this automatically :(
	mark_as_advanced(${lib}_INCLUDE_DIRS ${lib}_LIBRARIES ${lib}_LIBRARIES_DEBUG)
endforeach(lib)

# Client only libs
foreach(lib ${FINDCLIENTLIBS})
   find_package(${lib} REQUIRED)
   include_directories(${${lib}_INCLUDE_DIRS})
   list(APPEND CLIENTLIBS ${${lib}_LIBRARIES})
   add_definitions(${${lib}_DEFINITIONS})
   # Poor modules don't do this automatically :(
   mark_as_advanced(${lib}_INCLUDE_DIRS ${lib}_LIBRARIES ${lib}_LIBRARIES_DEBUG)
endforeach(lib)

# Master server has fewer deps
list(APPEND MASTER_SERVER_LIBS ${SDL_net_LIBRARIES})


# Targets

if(BUILD_CLIENT)
	add_executable(${EXENAME} ${CLIENT_SOURCES} ${COMMON_SOURCES} ${GUI_SOURCES})
	set_target_properties(${EXENAME} PROPERTIES COMPILE_FLAGS "-UDEDICATED")
	target_link_libraries(${EXENAME} ${CLIENTLIBS})
endif(BUILD_CLIENT)

if(BUILD_DEDICATED_SERVER)
	add_executable(server ${DEDICATED_SERVER_SOURCES} ${COMMON_SOURCES})
	set_target_properties(server PROPERTIES COMPILE_FLAGS "-DDEDICATED")
	target_link_libraries(server ${LIBS})
endif(BUILD_DEDICATED_SERVER)

if(BUILD_MASTER_SERVER)
	add_executable(master ${MASTER_SERVER_SOURCES})
	target_link_libraries(master ${MASTER_SERVER_LIBS})
endif(BUILD_MASTER_SERVER)

