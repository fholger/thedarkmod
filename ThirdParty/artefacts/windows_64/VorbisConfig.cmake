########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(Vorbis_FIND_QUIETLY)
    set(Vorbis_MESSAGE_MODE VERBOSE)
else()
    set(Vorbis_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/VorbisTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${vorbis_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(Vorbis_VERSION_STRING "1.3.7")
set(Vorbis_INCLUDE_DIRS ${vorbis_INCLUDE_DIRS_RELEASE} )
set(Vorbis_INCLUDE_DIR ${vorbis_INCLUDE_DIRS_RELEASE} )
set(Vorbis_LIBRARIES ${vorbis_LIBRARIES_RELEASE} )
set(Vorbis_DEFINITIONS ${vorbis_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${vorbis_BUILD_MODULES_PATHS_RELEASE} )
    message(${Vorbis_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


