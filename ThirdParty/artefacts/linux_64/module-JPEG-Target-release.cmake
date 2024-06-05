# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(libjpeg_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(libjpeg_FRAMEWORKS_FOUND_RELEASE "${libjpeg_FRAMEWORKS_RELEASE}" "${libjpeg_FRAMEWORK_DIRS_RELEASE}")

set(libjpeg_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET libjpeg_DEPS_TARGET)
    add_library(libjpeg_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET libjpeg_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${libjpeg_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${libjpeg_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### libjpeg_DEPS_TARGET to all of them
conan_package_library_targets("${libjpeg_LIBS_RELEASE}"    # libraries
                              "${libjpeg_LIB_DIRS_RELEASE}" # package_libdir
                              "${libjpeg_BIN_DIRS_RELEASE}" # package_bindir
                              "${libjpeg_LIBRARY_TYPE_RELEASE}"
                              "${libjpeg_IS_HOST_WINDOWS_RELEASE}"
                              libjpeg_DEPS_TARGET
                              libjpeg_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "libjpeg"    # package_name
                              "${libjpeg_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${libjpeg_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${libjpeg_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${libjpeg_LIBRARIES_TARGETS}>
                 )

    if("${libjpeg_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET JPEG::JPEG
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     libjpeg_DEPS_TARGET)
    endif()

    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${libjpeg_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${libjpeg_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${libjpeg_LIB_DIRS_RELEASE}>)
    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${libjpeg_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${libjpeg_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(libjpeg_LIBRARIES_RELEASE JPEG::JPEG)
