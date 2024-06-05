########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(tracy_FIND_QUIETLY)
    set(tracy_MESSAGE_MODE VERBOSE)
else()
    set(tracy_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tracyTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${tracy_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(tracy_VERSION_STRING "0.10")
set(tracy_INCLUDE_DIRS ${tracy_INCLUDE_DIRS_RELEASE} )
set(tracy_INCLUDE_DIR ${tracy_INCLUDE_DIRS_RELEASE} )
set(tracy_LIBRARIES ${tracy_LIBRARIES_RELEASE} )
set(tracy_DEFINITIONS ${tracy_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${tracy_BUILD_MODULES_PATHS_RELEASE} )
    message(${tracy_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


