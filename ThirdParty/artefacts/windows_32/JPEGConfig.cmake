########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(JPEG_FIND_QUIETLY)
    set(JPEG_MESSAGE_MODE VERBOSE)
else()
    set(JPEG_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/JPEGTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${libjpeg_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(JPEG_VERSION_STRING "9f")
set(JPEG_INCLUDE_DIRS ${libjpeg_INCLUDE_DIRS_RELEASE} )
set(JPEG_INCLUDE_DIR ${libjpeg_INCLUDE_DIRS_RELEASE} )
set(JPEG_LIBRARIES ${libjpeg_LIBRARIES_RELEASE} )
set(JPEG_DEFINITIONS ${libjpeg_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${libjpeg_BUILD_MODULES_PATHS_RELEASE} )
    message(${JPEG_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


