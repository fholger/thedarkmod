# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(mbedtls_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(mbedtls_FRAMEWORKS_FOUND_DEBUG "${mbedtls_FRAMEWORKS_DEBUG}" "${mbedtls_FRAMEWORK_DIRS_DEBUG}")

set(mbedtls_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET mbedtls_DEPS_TARGET)
    add_library(mbedtls_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET mbedtls_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${mbedtls_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${mbedtls_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:MbedTLS::mbedcrypto;MbedTLS::mbedx509>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### mbedtls_DEPS_TARGET to all of them
conan_package_library_targets("${mbedtls_LIBS_DEBUG}"    # libraries
                              "${mbedtls_LIB_DIRS_DEBUG}" # package_libdir
                              "${mbedtls_BIN_DIRS_DEBUG}" # package_bindir
                              "${mbedtls_LIBRARY_TYPE_DEBUG}"
                              "${mbedtls_IS_HOST_WINDOWS_DEBUG}"
                              mbedtls_DEPS_TARGET
                              mbedtls_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "mbedtls"    # package_name
                              "${mbedtls_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${mbedtls_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Debug ########################################

    ########## COMPONENT MbedTLS::mbedtls #############

        set(mbedtls_MbedTLS_mbedtls_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(mbedtls_MbedTLS_mbedtls_FRAMEWORKS_FOUND_DEBUG "${mbedtls_MbedTLS_mbedtls_FRAMEWORKS_DEBUG}" "${mbedtls_MbedTLS_mbedtls_FRAMEWORK_DIRS_DEBUG}")

        set(mbedtls_MbedTLS_mbedtls_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET mbedtls_MbedTLS_mbedtls_DEPS_TARGET)
            add_library(mbedtls_MbedTLS_mbedtls_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET mbedtls_MbedTLS_mbedtls_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedtls_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedtls_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedtls_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'mbedtls_MbedTLS_mbedtls_DEPS_TARGET' to all of them
        conan_package_library_targets("${mbedtls_MbedTLS_mbedtls_LIBS_DEBUG}"
                              "${mbedtls_MbedTLS_mbedtls_LIB_DIRS_DEBUG}"
                              "${mbedtls_MbedTLS_mbedtls_BIN_DIRS_DEBUG}" # package_bindir
                              "${mbedtls_MbedTLS_mbedtls_LIBRARY_TYPE_DEBUG}"
                              "${mbedtls_MbedTLS_mbedtls_IS_HOST_WINDOWS_DEBUG}"
                              mbedtls_MbedTLS_mbedtls_DEPS_TARGET
                              mbedtls_MbedTLS_mbedtls_LIBRARIES_TARGETS
                              "_DEBUG"
                              "mbedtls_MbedTLS_mbedtls"
                              "${mbedtls_MbedTLS_mbedtls_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET MbedTLS::mbedtls
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedtls_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedtls_LIBRARIES_TARGETS}>
                     )

        if("${mbedtls_MbedTLS_mbedtls_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET MbedTLS::mbedtls
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         mbedtls_MbedTLS_mbedtls_DEPS_TARGET)
        endif()

        set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedtls_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedtls_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedtls_LIB_DIRS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedtls_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_DEBUG}>)

    ########## COMPONENT MbedTLS::mbedx509 #############

        set(mbedtls_MbedTLS_mbedx509_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(mbedtls_MbedTLS_mbedx509_FRAMEWORKS_FOUND_DEBUG "${mbedtls_MbedTLS_mbedx509_FRAMEWORKS_DEBUG}" "${mbedtls_MbedTLS_mbedx509_FRAMEWORK_DIRS_DEBUG}")

        set(mbedtls_MbedTLS_mbedx509_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET mbedtls_MbedTLS_mbedx509_DEPS_TARGET)
            add_library(mbedtls_MbedTLS_mbedx509_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET mbedtls_MbedTLS_mbedx509_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedx509_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedx509_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedx509_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'mbedtls_MbedTLS_mbedx509_DEPS_TARGET' to all of them
        conan_package_library_targets("${mbedtls_MbedTLS_mbedx509_LIBS_DEBUG}"
                              "${mbedtls_MbedTLS_mbedx509_LIB_DIRS_DEBUG}"
                              "${mbedtls_MbedTLS_mbedx509_BIN_DIRS_DEBUG}" # package_bindir
                              "${mbedtls_MbedTLS_mbedx509_LIBRARY_TYPE_DEBUG}"
                              "${mbedtls_MbedTLS_mbedx509_IS_HOST_WINDOWS_DEBUG}"
                              mbedtls_MbedTLS_mbedx509_DEPS_TARGET
                              mbedtls_MbedTLS_mbedx509_LIBRARIES_TARGETS
                              "_DEBUG"
                              "mbedtls_MbedTLS_mbedx509"
                              "${mbedtls_MbedTLS_mbedx509_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET MbedTLS::mbedx509
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedx509_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedx509_LIBRARIES_TARGETS}>
                     )

        if("${mbedtls_MbedTLS_mbedx509_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET MbedTLS::mbedx509
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         mbedtls_MbedTLS_mbedx509_DEPS_TARGET)
        endif()

        set_property(TARGET MbedTLS::mbedx509 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedx509_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedx509 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedx509_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedx509 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedx509_LIB_DIRS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedx509 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedx509_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedx509 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_DEBUG}>)

    ########## COMPONENT MbedTLS::mbedcrypto #############

        set(mbedtls_MbedTLS_mbedcrypto_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(mbedtls_MbedTLS_mbedcrypto_FRAMEWORKS_FOUND_DEBUG "${mbedtls_MbedTLS_mbedcrypto_FRAMEWORKS_DEBUG}" "${mbedtls_MbedTLS_mbedcrypto_FRAMEWORK_DIRS_DEBUG}")

        set(mbedtls_MbedTLS_mbedcrypto_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET)
            add_library(mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedcrypto_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedcrypto_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedcrypto_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET' to all of them
        conan_package_library_targets("${mbedtls_MbedTLS_mbedcrypto_LIBS_DEBUG}"
                              "${mbedtls_MbedTLS_mbedcrypto_LIB_DIRS_DEBUG}"
                              "${mbedtls_MbedTLS_mbedcrypto_BIN_DIRS_DEBUG}" # package_bindir
                              "${mbedtls_MbedTLS_mbedcrypto_LIBRARY_TYPE_DEBUG}"
                              "${mbedtls_MbedTLS_mbedcrypto_IS_HOST_WINDOWS_DEBUG}"
                              mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET
                              mbedtls_MbedTLS_mbedcrypto_LIBRARIES_TARGETS
                              "_DEBUG"
                              "mbedtls_MbedTLS_mbedcrypto"
                              "${mbedtls_MbedTLS_mbedcrypto_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET MbedTLS::mbedcrypto
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedcrypto_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedcrypto_LIBRARIES_TARGETS}>
                     )

        if("${mbedtls_MbedTLS_mbedcrypto_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET MbedTLS::mbedcrypto
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         mbedtls_MbedTLS_mbedcrypto_DEPS_TARGET)
        endif()

        set_property(TARGET MbedTLS::mbedcrypto APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedcrypto_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedcrypto APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedcrypto_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedcrypto APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedcrypto_LIB_DIRS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedcrypto APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedcrypto_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET MbedTLS::mbedcrypto APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_DEBUG}>)

    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_LINK_LIBRARIES MbedTLS::mbedtls)
    set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_LINK_LIBRARIES MbedTLS::mbedx509)
    set_property(TARGET MbedTLS::mbedtls APPEND PROPERTY INTERFACE_LINK_LIBRARIES MbedTLS::mbedcrypto)

########## For the modules (FindXXX)
set(mbedtls_LIBRARIES_DEBUG MbedTLS::mbedtls)
