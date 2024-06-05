# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(fltk_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(fltk_FRAMEWORKS_FOUND_RELEASE "${fltk_FRAMEWORKS_RELEASE}" "${fltk_FRAMEWORK_DIRS_RELEASE}")

set(fltk_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET fltk_DEPS_TARGET)
    add_library(fltk_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET fltk_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${fltk_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${fltk_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:JPEG::JPEG;PNG::PNG;ZLIB::ZLIB>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### fltk_DEPS_TARGET to all of them
conan_package_library_targets("${fltk_LIBS_RELEASE}"    # libraries
                              "${fltk_LIB_DIRS_RELEASE}" # package_libdir
                              "${fltk_BIN_DIRS_RELEASE}" # package_bindir
                              "${fltk_LIBRARY_TYPE_RELEASE}"
                              "${fltk_IS_HOST_WINDOWS_RELEASE}"
                              fltk_DEPS_TARGET
                              fltk_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "fltk"    # package_name
                              "${fltk_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${fltk_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${fltk_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${fltk_LIBRARIES_TARGETS}>
                 )

    if("${fltk_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET fltk::fltk
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     fltk_DEPS_TARGET)
    endif()

    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${fltk_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${fltk_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${fltk_LIB_DIRS_RELEASE}>)
    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${fltk_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${fltk_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(fltk_LIBRARIES_RELEASE fltk::fltk)
