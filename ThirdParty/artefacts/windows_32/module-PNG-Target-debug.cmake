# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(libpng_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(libpng_FRAMEWORKS_FOUND_DEBUG "${libpng_FRAMEWORKS_DEBUG}" "${libpng_FRAMEWORK_DIRS_DEBUG}")

set(libpng_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET libpng_DEPS_TARGET)
    add_library(libpng_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET libpng_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${libpng_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${libpng_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:ZLIB::ZLIB>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### libpng_DEPS_TARGET to all of them
conan_package_library_targets("${libpng_LIBS_DEBUG}"    # libraries
                              "${libpng_LIB_DIRS_DEBUG}" # package_libdir
                              "${libpng_BIN_DIRS_DEBUG}" # package_bindir
                              "${libpng_LIBRARY_TYPE_DEBUG}"
                              "${libpng_IS_HOST_WINDOWS_DEBUG}"
                              libpng_DEPS_TARGET
                              libpng_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "libpng"    # package_name
                              "${libpng_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${libpng_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET PNG::PNG
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${libpng_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${libpng_LIBRARIES_TARGETS}>
                 )

    if("${libpng_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET PNG::PNG
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     libpng_DEPS_TARGET)
    endif()

    set_property(TARGET PNG::PNG
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${libpng_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET PNG::PNG
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${libpng_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET PNG::PNG
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${libpng_LIB_DIRS_DEBUG}>)
    set_property(TARGET PNG::PNG
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${libpng_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET PNG::PNG
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${libpng_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(libpng_LIBRARIES_DEBUG PNG::PNG)
