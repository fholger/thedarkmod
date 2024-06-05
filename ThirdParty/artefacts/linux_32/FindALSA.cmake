########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(ALSA_FIND_QUIETLY)
    set(ALSA_MESSAGE_MODE VERBOSE)
else()
    set(ALSA_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/module-ALSATargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${libalsa_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(ALSA_VERSION_STRING "1.2.7.2")
set(ALSA_INCLUDE_DIRS ${libalsa_INCLUDE_DIRS_RELEASE} )
set(ALSA_INCLUDE_DIR ${libalsa_INCLUDE_DIRS_RELEASE} )
set(ALSA_LIBRARIES ${libalsa_LIBRARIES_RELEASE} )
set(ALSA_DEFINITIONS ${libalsa_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${libalsa_BUILD_MODULES_PATHS_RELEASE} )
    message(${ALSA_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


include(FindPackageHandleStandardArgs)
set(ALSA_FOUND 1)
set(ALSA_VERSION "1.2.7.2")

find_package_handle_standard_args(ALSA
                                  REQUIRED_VARS ALSA_VERSION
                                  VERSION_VAR ALSA_VERSION)
mark_as_advanced(ALSA_FOUND ALSA_VERSION)
