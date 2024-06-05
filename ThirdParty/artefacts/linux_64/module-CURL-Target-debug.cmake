# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(libcurl_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(libcurl_FRAMEWORKS_FOUND_DEBUG "${libcurl_FRAMEWORKS_DEBUG}" "${libcurl_FRAMEWORK_DIRS_DEBUG}")

set(libcurl_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET libcurl_DEPS_TARGET)
    add_library(libcurl_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET libcurl_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${libcurl_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${libcurl_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:MbedTLS::mbedtls;ZLIB::ZLIB>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### libcurl_DEPS_TARGET to all of them
conan_package_library_targets("${libcurl_LIBS_DEBUG}"    # libraries
                              "${libcurl_LIB_DIRS_DEBUG}" # package_libdir
                              "${libcurl_BIN_DIRS_DEBUG}" # package_bindir
                              "${libcurl_LIBRARY_TYPE_DEBUG}"
                              "${libcurl_IS_HOST_WINDOWS_DEBUG}"
                              libcurl_DEPS_TARGET
                              libcurl_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "libcurl"    # package_name
                              "${libcurl_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${libcurl_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Debug ########################################

    ########## COMPONENT CURL::libcurl #############

        set(libcurl_CURL_libcurl_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(libcurl_CURL_libcurl_FRAMEWORKS_FOUND_DEBUG "${libcurl_CURL_libcurl_FRAMEWORKS_DEBUG}" "${libcurl_CURL_libcurl_FRAMEWORK_DIRS_DEBUG}")

        set(libcurl_CURL_libcurl_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET libcurl_CURL_libcurl_DEPS_TARGET)
            add_library(libcurl_CURL_libcurl_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET libcurl_CURL_libcurl_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${libcurl_CURL_libcurl_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${libcurl_CURL_libcurl_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${libcurl_CURL_libcurl_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'libcurl_CURL_libcurl_DEPS_TARGET' to all of them
        conan_package_library_targets("${libcurl_CURL_libcurl_LIBS_DEBUG}"
                              "${libcurl_CURL_libcurl_LIB_DIRS_DEBUG}"
                              "${libcurl_CURL_libcurl_BIN_DIRS_DEBUG}" # package_bindir
                              "${libcurl_CURL_libcurl_LIBRARY_TYPE_DEBUG}"
                              "${libcurl_CURL_libcurl_IS_HOST_WINDOWS_DEBUG}"
                              libcurl_CURL_libcurl_DEPS_TARGET
                              libcurl_CURL_libcurl_LIBRARIES_TARGETS
                              "_DEBUG"
                              "libcurl_CURL_libcurl"
                              "${libcurl_CURL_libcurl_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET CURL::libcurl
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${libcurl_CURL_libcurl_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${libcurl_CURL_libcurl_LIBRARIES_TARGETS}>
                     )

        if("${libcurl_CURL_libcurl_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET CURL::libcurl
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         libcurl_CURL_libcurl_DEPS_TARGET)
        endif()

        set_property(TARGET CURL::libcurl APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${libcurl_CURL_libcurl_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET CURL::libcurl APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${libcurl_CURL_libcurl_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET CURL::libcurl APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${libcurl_CURL_libcurl_LIB_DIRS_DEBUG}>)
        set_property(TARGET CURL::libcurl APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${libcurl_CURL_libcurl_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET CURL::libcurl APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${libcurl_CURL_libcurl_COMPILE_OPTIONS_DEBUG}>)

    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET CURL::libcurl APPEND PROPERTY INTERFACE_LINK_LIBRARIES CURL::libcurl)

########## For the modules (FindXXX)
set(libcurl_LIBRARIES_DEBUG CURL::libcurl)
