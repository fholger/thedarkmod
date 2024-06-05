# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(fltk_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(fltk_FRAMEWORKS_FOUND_DEBUG "${fltk_FRAMEWORKS_DEBUG}" "${fltk_FRAMEWORK_DIRS_DEBUG}")

set(fltk_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET fltk_DEPS_TARGET)
    add_library(fltk_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET fltk_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${fltk_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${fltk_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:JPEG::JPEG;PNG::PNG;ZLIB::ZLIB>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### fltk_DEPS_TARGET to all of them
conan_package_library_targets("${fltk_LIBS_DEBUG}"    # libraries
                              "${fltk_LIB_DIRS_DEBUG}" # package_libdir
                              "${fltk_BIN_DIRS_DEBUG}" # package_bindir
                              "${fltk_LIBRARY_TYPE_DEBUG}"
                              "${fltk_IS_HOST_WINDOWS_DEBUG}"
                              fltk_DEPS_TARGET
                              fltk_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "fltk"    # package_name
                              "${fltk_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${fltk_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${fltk_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${fltk_LIBRARIES_TARGETS}>
                 )

    if("${fltk_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET fltk::fltk
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     fltk_DEPS_TARGET)
    endif()

    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${fltk_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${fltk_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${fltk_LIB_DIRS_DEBUG}>)
    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${fltk_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET fltk::fltk
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${fltk_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(fltk_LIBRARIES_DEBUG fltk::fltk)
