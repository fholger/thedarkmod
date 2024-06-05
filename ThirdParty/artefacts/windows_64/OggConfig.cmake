########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(Ogg_FIND_QUIETLY)
    set(Ogg_MESSAGE_MODE VERBOSE)
else()
    set(Ogg_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/OggTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${ogg_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(Ogg_VERSION_STRING "1.3.5")
set(Ogg_INCLUDE_DIRS ${ogg_INCLUDE_DIRS_RELEASE} )
set(Ogg_INCLUDE_DIR ${ogg_INCLUDE_DIRS_RELEASE} )
set(Ogg_LIBRARIES ${ogg_LIBRARIES_RELEASE} )
set(Ogg_DEFINITIONS ${ogg_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${ogg_BUILD_MODULES_PATHS_RELEASE} )
    message(${Ogg_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


