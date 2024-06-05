# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(minizip_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(minizip_FRAMEWORKS_FOUND_RELEASE "${minizip_FRAMEWORKS_RELEASE}" "${minizip_FRAMEWORK_DIRS_RELEASE}")

set(minizip_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET minizip_DEPS_TARGET)
    add_library(minizip_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET minizip_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${minizip_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${minizip_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:ZLIB::ZLIB>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### minizip_DEPS_TARGET to all of them
conan_package_library_targets("${minizip_LIBS_RELEASE}"    # libraries
                              "${minizip_LIB_DIRS_RELEASE}" # package_libdir
                              "${minizip_BIN_DIRS_RELEASE}" # package_bindir
                              "${minizip_LIBRARY_TYPE_RELEASE}"
                              "${minizip_IS_HOST_WINDOWS_RELEASE}"
                              minizip_DEPS_TARGET
                              minizip_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "minizip"    # package_name
                              "${minizip_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${minizip_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${minizip_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${minizip_LIBRARIES_TARGETS}>
                 )

    if("${minizip_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET minizip::minizip
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     minizip_DEPS_TARGET)
    endif()

    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${minizip_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${minizip_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${minizip_LIB_DIRS_RELEASE}>)
    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${minizip_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET minizip::minizip
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${minizip_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(minizip_LIBRARIES_RELEASE minizip::minizip)
