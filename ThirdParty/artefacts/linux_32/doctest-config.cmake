########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(doctest_FIND_QUIETLY)
    set(doctest_MESSAGE_MODE VERBOSE)
else()
    set(doctest_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/doctestTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${doctest_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(doctest_VERSION_STRING "2.4.11")
set(doctest_INCLUDE_DIRS ${doctest_INCLUDE_DIRS_RELEASE} )
set(doctest_INCLUDE_DIR ${doctest_INCLUDE_DIRS_RELEASE} )
set(doctest_LIBRARIES ${doctest_LIBRARIES_RELEASE} )
set(doctest_DEFINITIONS ${doctest_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${doctest_BUILD_MODULES_PATHS_RELEASE} )
    message(${doctest_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


