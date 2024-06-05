# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(libjpeg_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(libjpeg_FRAMEWORKS_FOUND_DEBUG "${libjpeg_FRAMEWORKS_DEBUG}" "${libjpeg_FRAMEWORK_DIRS_DEBUG}")

set(libjpeg_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET libjpeg_DEPS_TARGET)
    add_library(libjpeg_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET libjpeg_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${libjpeg_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${libjpeg_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### libjpeg_DEPS_TARGET to all of them
conan_package_library_targets("${libjpeg_LIBS_DEBUG}"    # libraries
                              "${libjpeg_LIB_DIRS_DEBUG}" # package_libdir
                              "${libjpeg_BIN_DIRS_DEBUG}" # package_bindir
                              "${libjpeg_LIBRARY_TYPE_DEBUG}"
                              "${libjpeg_IS_HOST_WINDOWS_DEBUG}"
                              libjpeg_DEPS_TARGET
                              libjpeg_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "libjpeg"    # package_name
                              "${libjpeg_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${libjpeg_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${libjpeg_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${libjpeg_LIBRARIES_TARGETS}>
                 )

    if("${libjpeg_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET JPEG::JPEG
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     libjpeg_DEPS_TARGET)
    endif()

    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${libjpeg_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${libjpeg_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${libjpeg_LIB_DIRS_DEBUG}>)
    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${libjpeg_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET JPEG::JPEG
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${libjpeg_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(libjpeg_LIBRARIES_DEBUG JPEG::JPEG)
