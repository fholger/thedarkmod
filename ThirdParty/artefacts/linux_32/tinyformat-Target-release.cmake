# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(tinyformat_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(tinyformat_FRAMEWORKS_FOUND_RELEASE "${tinyformat_FRAMEWORKS_RELEASE}" "${tinyformat_FRAMEWORK_DIRS_RELEASE}")

set(tinyformat_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET tinyformat_DEPS_TARGET)
    add_library(tinyformat_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET tinyformat_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${tinyformat_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${tinyformat_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### tinyformat_DEPS_TARGET to all of them
conan_package_library_targets("${tinyformat_LIBS_RELEASE}"    # libraries
                              "${tinyformat_LIB_DIRS_RELEASE}" # package_libdir
                              "${tinyformat_BIN_DIRS_RELEASE}" # package_bindir
                              "${tinyformat_LIBRARY_TYPE_RELEASE}"
                              "${tinyformat_IS_HOST_WINDOWS_RELEASE}"
                              tinyformat_DEPS_TARGET
                              tinyformat_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "tinyformat"    # package_name
                              "${tinyformat_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${tinyformat_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${tinyformat_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${tinyformat_LIBRARIES_TARGETS}>
                 )

    if("${tinyformat_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET tinyformat::tinyformat
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     tinyformat_DEPS_TARGET)
    endif()

    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${tinyformat_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${tinyformat_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${tinyformat_LIB_DIRS_RELEASE}>)
    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${tinyformat_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET tinyformat::tinyformat
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${tinyformat_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(tinyformat_LIBRARIES_RELEASE tinyformat::tinyformat)
