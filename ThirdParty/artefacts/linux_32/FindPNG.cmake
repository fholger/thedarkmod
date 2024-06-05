########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(PNG_FIND_QUIETLY)
    set(PNG_MESSAGE_MODE VERBOSE)
else()
    set(PNG_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/module-PNGTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${libpng_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(PNG_VERSION_STRING "1.6.43")
set(PNG_INCLUDE_DIRS ${libpng_INCLUDE_DIRS_RELEASE} )
set(PNG_INCLUDE_DIR ${libpng_INCLUDE_DIRS_RELEASE} )
set(PNG_LIBRARIES ${libpng_LIBRARIES_RELEASE} )
set(PNG_DEFINITIONS ${libpng_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${libpng_BUILD_MODULES_PATHS_RELEASE} )
    message(${PNG_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


include(FindPackageHandleStandardArgs)
set(PNG_FOUND 1)
set(PNG_VERSION "1.6.43")

find_package_handle_standard_args(PNG
                                  REQUIRED_VARS PNG_VERSION
                                  VERSION_VAR PNG_VERSION)
mark_as_advanced(PNG_FOUND PNG_VERSION)
