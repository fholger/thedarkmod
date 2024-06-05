########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(MbedTLS_FIND_QUIETLY)
    set(MbedTLS_MESSAGE_MODE VERBOSE)
else()
    set(MbedTLS_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/MbedTLSTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${mbedtls_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(MbedTLS_VERSION_STRING "3.6.0")
set(MbedTLS_INCLUDE_DIRS ${mbedtls_INCLUDE_DIRS_RELEASE} )
set(MbedTLS_INCLUDE_DIR ${mbedtls_INCLUDE_DIRS_RELEASE} )
set(MbedTLS_LIBRARIES ${mbedtls_LIBRARIES_RELEASE} )
set(MbedTLS_DEFINITIONS ${mbedtls_DEFINITIONS_RELEASE} )

# Only the first installed configuration is included to avoid the collision
foreach(_BUILD_MODULE ${mbedtls_BUILD_MODULES_PATHS_RELEASE} )
    message(${MbedTLS_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


