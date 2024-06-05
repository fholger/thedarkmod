# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(minizip_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(minizip_FRAMEWORKS_FOUND_DEBUG "${minizip_FRAMEWORKS_DEBUG}" "${minizip_FRAMEWORK_DIRS_DEBUG}")

set(minizip_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET minizip_DEPS_TARGET)
    add_library(minizip_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET minizip_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${minizip_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${minizip_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:ZLIB::ZLIB>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### minizip_DEPS_TARGET to all of them
conan_package_library_targets("${minizip_LIBS_DEBUG}"    # libraries
                              "${minizip_LIB_DIRS_DEBUG}" # package_libdir
                              "${minizip_BIN_DIRS_DEBUG}" # package_bindir
                              "${minizip_LIBRARY_TYPE_DEBUG}"
                              "${minizip_IS_HOST_WINDOWS_DEBUG}"
                              minizip_DEPS_TARGET
                              minizip_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "minizip"    # package_name
                              "${minizip_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${minizip_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${minizip_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${minizip_LIBRARIES_TARGETS}>
                 )

    if("${minizip_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET minizip::minizip
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     minizip_DEPS_TARGET)
    endif()

    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${minizip_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${minizip_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${minizip_LIB_DIRS_DEBUG}>)
    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${minizip_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${minizip_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(minizip_LIBRARIES_DEBUG minizip::minizip)
