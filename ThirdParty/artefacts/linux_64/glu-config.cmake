########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(glu_FIND_QUIETLY)
    set(glu_MESSAGE_MODE VERBOSE)
else()
    set(glu_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/gluTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${glu_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(glu_VERSION_STRING "system")
set(glu_INCLUDE_DIRS ${glu_INCLUDE_DIRS_RELEASE} )
set(glu_INCLUDE_DIR ${glu_INCLUDE_DIRS_RELEASE} )
set(glu_LIBRARIES ${glu_LIBRARIES_RELEASE} )
set(glu_DEFINITIONS ${glu_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${glu_BUILD_MODULES_PATHS_RELEASE} )
    message(${glu_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


