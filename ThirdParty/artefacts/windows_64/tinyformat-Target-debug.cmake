# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(tinyformat_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(tinyformat_FRAMEWORKS_FOUND_DEBUG "${tinyformat_FRAMEWORKS_DEBUG}" "${tinyformat_FRAMEWORK_DIRS_DEBUG}")

set(tinyformat_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET tinyformat_DEPS_TARGET)
    add_library(tinyformat_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET tinyformat_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${tinyformat_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${tinyformat_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### tinyformat_DEPS_TARGET to all of them
conan_package_library_targets("${tinyformat_LIBS_DEBUG}"    # libraries
                              "${tinyformat_LIB_DIRS_DEBUG}" # package_libdir
                              "${tinyformat_BIN_DIRS_DEBUG}" # package_bindir
                              "${tinyformat_LIBRARY_TYPE_DEBUG}"
                              "${tinyformat_IS_HOST_WINDOWS_DEBUG}"
                              tinyformat_DEPS_TARGET
                              tinyformat_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "tinyformat"    # package_name
                              "${tinyformat_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${tinyformat_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${tinyformat_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${tinyformat_LIBRARIES_TARGETS}>
                 )

    if("${tinyformat_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET tinyformat::tinyformat
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     tinyformat_DEPS_TARGET)
    endif()

    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${tinyformat_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${tinyformat_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${tinyformat_LIB_DIRS_DEBUG}>)
    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${tinyformat_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${tinyformat_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(tinyformat_LIBRARIES_DEBUG tinyformat::tinyformat)
