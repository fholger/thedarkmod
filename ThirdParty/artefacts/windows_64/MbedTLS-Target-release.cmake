# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(mbedtls_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(mbedtls_FRAMEWORKS_FOUND_RELEASE "${mbedtls_FRAMEWORKS_RELEASE}" "${mbedtls_FRAMEWORK_DIRS_RELEASE}")

set(mbedtls_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET mbedtls_DEPS_TARGET)
    add_library(mbedtls_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET mbedtls_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${mbedtls_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${mbedtls_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:MbedTLS::mbedcrypto;MbedTLS::mbedx509>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### mbedtls_DEPS_TARGET to all of them
conan_package_library_targets("${mbedtls_LIBS_RELEASE}"    # libraries
                              "${mbedtls_LIB_DIRS_RELEASE}" # package_libdir
                              "${mbedtls_BIN_DIRS_RELEASE}" # package_bindir
                              "${mbedtls_LIBRARY_TYPE_RELEASE}"
                              "${mbedtls_IS_HOST_WINDOWS_RELEASE}"
                              mbedtls_DEPS_TARGET
                              mbedtls_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "mbedtls"    # package_name
                              "${mbedtls_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${mbedtls_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Release ########################################

    ########## COMPONENT MbedTLS::mbedtls #############

        set(mbedtls_MbedTLS_mbedtls_FRAMEWORKS_FOUND_RELEASE "")
        conan_find_apple_frameworks(mbedtls_MbedTLS_mbedtls_FRAMEWORKS_FOUND_RELEASE "${mbedtls_MbedTLS_mbedtls_FRAMEWORKS_RELEASE}" "${mbedtls_MbedTLS_mbedtls_FRAMEWORK_DIRS_RELEASE}")

        set(mbedtls_MbedTLS_mbedtls_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET mbedtls_MbedTLS_mbedtls_DEPS_TARGET)
            add_library(mbedtls_MbedTLS_mbedtls_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET mbedtls_MbedTLS_mbedtls_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedtls_FRAMEWORKS_FOUND_RELEASE}>
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedtls_SYSTEM_LIBS_RELEASE}>
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedtls_DEPENDENCIES_RELEASE}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'mbedtls_MbedTLS_mbedtls_DEPS_TARGET' to all of them
        conan_package_library_targets("${mbedtls_MbedTLS_mbedtls_LIBS_RELEASE}"
                              "${mbedtls_MbedTLS_mbedtls_LIB_DIRS_RELEASE}"
                              "${mbedtls_MbedTLS_mbedtls_BIN_DIRS_RELEASE}" # package_bindir
                              "${mbedtls_MbedTLS_mbedtls_LIBRARY_TYPE_RELEASE}"
                              "${mbedtls_MbedTLS_mbedtls_IS_HOST_WINDOWS_RELEASE}"
                              mbedtls_MbedTLS_mbedtls_DEPS_TARGET
                              mbedtls_MbedTLS_mbedtls_LIBRARIES_TARGETS
                              "_RELEASE"
                              "mbedtls_MbedTLS_mbedtls"
                              "${mbedtls_MbedTLS_mbedtls_NO_SONAME_MODE_RELEASE}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET MbedTLS::mbedtls
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedtls_OBJECTS_RELEASE}>
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedtls_LIBRARIES_TARGETS}>
                     )

        if("${mbedtls_MbedTLS_mbedtls_LIBS_RELEASE}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET MbedTLS::mbedtls
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         mbedtls_MbedTLS_mbedtls_DEPS_TARGET)
        endif()

        set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedtls_LINKER_FLAGS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedtls_INCLUDE_DIRS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedtls_LIB_DIRS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedtls_COMPILE_DEFINITIONS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_RELEASE}>)

    ########## COMPONENT MbedTLS::mbedx509 #############

        set(mbedtls_MbedTLS_mbedx509_FRAMEWORKS_FOUND_RELEASE "")
        conan_find_apple_frameworks(mbedtls_MbedTLS_mbedx509_FRAMEWORKS_FOUND_RELEASE "${mbedtls_MbedTLS_mbedx509_FRAMEWORKS_RELEASE}" "${mbedtls_MbedTLS_mbedx509_FRAMEWORK_DIRS_RELEASE}")

        set(mbedtls_MbedTLS_mbedx509_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET mbedtls_MbedTLS_mbedx509_DEPS_TARGET)
            add_library(mbedtls_MbedTLS_mbedx509_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET mbedtls_MbedTLS_mbedx509_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedx509_FRAMEWORKS_FOUND_RELEASE}>
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedx509_SYSTEM_LIBS_RELEASE}>
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedx509_DEPENDENCIES_RELEASE}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'mbedtls_MbedTLS_mbedx509_DEPS_TARGET' to all of them
        conan_package_library_targets("${mbedtls_MbedTLS_mbedx509_LIBS_RELEASE}"
                              "${mbedtls_MbedTLS_mbedx509_LIB_DIRS_RELEASE}"
                              "${mbedtls_MbedTLS_mbedx509_BIN_DIRS_RELEASE}" # package_bindir
                              "${mbedtls_MbedTLS_mbedx509_LIBRARY_TYPE_RELEASE}"
                              "${mbedtls_MbedTLS_mbedx509_IS_HOST_WINDOWS_RELEASE}"
                              mbedtls_MbedTLS_mbedx509_DEPS_TARGET
                              mbedtls_MbedTLS_mbedx509_LIBRARIES_TARGETS
                              "_RELEASE"
                              "mbedtls_MbedTLS_mbedx509"
                              "${mbedtls_MbedTLS_mbedx509_NO_SONAME_MODE_RELEASE}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET MbedTLS::mbedx509
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedx509_OBJECTS_RELEASE}>
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedx509_LIBRARIES_TARGETS}>
                     )

        if("${mbedtls_MbedTLS_mbedx509_LIBS_RELEASE}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET MbedTLS::mbedx509
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         mbedtls_MbedTLS_mbedx509_DEPS_TARGET)
        endif()

        set_property(TARGET MbedTLS::mbedx509 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedx509_LINKER_FLAGS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedx509 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedx509_INCLUDE_DIRS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedx509 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedx509_LIB_DIRS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedx509 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedx509_COMPILE_DEFINITIONS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedx509 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_RELEASE}>)

    ########## COMPONENT MbedTLS::mbedcrypto #############

        set(mbedtls_MbedTLS_mbedcrypto_FRAMEWORKS_FOUND_RELEASE "")
        conan_find_apple_frameworks(mbedtls_MbedTLS_mbedcrypto_FRAMEWORKS_FOUND_RELEASE "${mbedtls_MbedTLS_mbedcrypto_FRAMEWORKS_RELEASE}" "${mbedtls_MbedTLS_mbedcrypto_FRAMEWORK_DIRS_RELEASE}")

        set(mbedtls_MbedTLS_mbedcrypto_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET)
            add_library(mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedcrypto_FRAMEWORKS_FOUND_RELEASE}>
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedcrypto_SYSTEM_LIBS_RELEASE}>
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedcrypto_DEPENDENCIES_RELEASE}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET' to all of them
        conan_package_library_targets("${mbedtls_MbedTLS_mbedcrypto_LIBS_RELEASE}"
                              "${mbedtls_MbedTLS_mbedcrypto_LIB_DIRS_RELEASE}"
                              "${mbedtls_MbedTLS_mbedcrypto_BIN_DIRS_RELEASE}" # package_bindir
                              "${mbedtls_MbedTLS_mbedcrypto_LIBRARY_TYPE_RELEASE}"
                              "${mbedtls_MbedTLS_mbedcrypto_IS_HOST_WINDOWS_RELEASE}"
                              mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET
                              mbedtls_MbedTLS_mbedcrypto_LIBRARIES_TARGETS
                              "_RELEASE"
                              "mbedtls_MbedTLS_mbedcrypto"
                              "${mbedtls_MbedTLS_mbedcrypto_NO_SONAME_MODE_RELEASE}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET MbedTLS::mbedcrypto
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedcrypto_OBJECTS_RELEASE}>
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedcrypto_LIBRARIES_TARGETS}>
                     )

        if("${mbedtls_MbedTLS_mbedcrypto_LIBS_RELEASE}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET MbedTLS::mbedcrypto
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET)
        endif()

        set_property(TARGET MbedTLS::mbedcrypto APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedcrypto_LINKER_FLAGS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedcrypto APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedcrypto_INCLUDE_DIRS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedcrypto APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedcrypto_LIB_DIRS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedcrypto APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedcrypto_COMPILE_DEFINITIONS_RELEASE}>)
        set_property(TARGET MbedTLS::mbedcrypto APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Release>:${mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_RELEASE}>)

    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_LINK_LIBRARIES MbedTLS::mbedtls)
    set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_LINK_LIBRARIES MbedTLS::mbedx509)
    set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_LINK_LIBRARIES MbedTLS::mbedcrypto)

########## For the modules (FindXXX)
set(mbedtls_LIBRARIES_RELEASE MbedTLS::mbedtls)
