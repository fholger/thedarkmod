########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(OpenAL_FIND_QUIETLY)
    set(OpenAL_MESSAGE_MODE VERBOSE)
else()
    set(OpenAL_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/OpenALTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${openal_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(OpenAL_VERSION_STRING "1.22.2")
set(OpenAL_INCLUDE_DIRS ${openal_INCLUDE_DIRS_RELEASE} )
set(OpenAL_INCLUDE_DIR ${openal_INCLUDE_DIRS_RELEASE} )
set(OpenAL_LIBRARIES ${openal_LIBRARIES_RELEASE} )
set(OpenAL_DEFINITIONS ${openal_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${openal_BUILD_MODULES_PATHS_RELEASE} )
    message(${OpenAL_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


