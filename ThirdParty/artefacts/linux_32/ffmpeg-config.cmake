########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(ffmpeg_FIND_QUIETLY)
    set(ffmpeg_MESSAGE_MODE VERBOSE)
else()
    set(ffmpeg_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ffmpegTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${ffmpeg_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(ffmpeg_VERSION_STRING "6.1")
set(ffmpeg_INCLUDE_DIRS ${ffmpeg_INCLUDE_DIRS_RELEASE} )
set(ffmpeg_INCLUDE_DIR ${ffmpeg_INCLUDE_DIRS_RELEASE} )
set(ffmpeg_LIBRARIES ${ffmpeg_LIBRARIES_RELEASE} )
set(ffmpeg_DEFINITIONS ${ffmpeg_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${ffmpeg_BUILD_MODULES_PATHS_RELEASE} )
    message(${ffmpeg_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


