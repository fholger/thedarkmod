########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(fltk_FIND_QUIETLY)
    set(fltk_MESSAGE_MODE VERBOSE)
else()
    set(fltk_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/fltkTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${fltk_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(fltk_VERSION_STRING "1.3.9")
set(fltk_INCLUDE_DIRS ${fltk_INCLUDE_DIRS_RELEASE} )
set(fltk_INCLUDE_DIR ${fltk_INCLUDE_DIRS_RELEASE} )
set(fltk_LIBRARIES ${fltk_LIBRARIES_RELEASE} )
set(fltk_DEFINITIONS ${fltk_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${fltk_BUILD_MODULES_PATHS_RELEASE} )
    message(${fltk_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


