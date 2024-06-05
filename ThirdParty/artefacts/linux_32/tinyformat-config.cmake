########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(tinyformat_FIND_QUIETLY)
    set(tinyformat_MESSAGE_MODE VERBOSE)
else()
    set(tinyformat_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/tinyformatTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${tinyformat_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(tinyformat_VERSION_STRING "2.3.0")
set(tinyformat_INCLUDE_DIRS ${tinyformat_INCLUDE_DIRS_RELEASE} )
set(tinyformat_INCLUDE_DIR ${tinyformat_INCLUDE_DIRS_RELEASE} )
set(tinyformat_LIBRARIES ${tinyformat_LIBRARIES_RELEASE} )
set(tinyformat_DEFINITIONS ${tinyformat_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${tinyformat_BUILD_MODULES_PATHS_RELEASE} )
    message(${tinyformat_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


