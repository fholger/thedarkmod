# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(doctest_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(doctest_FRAMEWORKS_FOUND_RELEASE "${doctest_FRAMEWORKS_RELEASE}" "${doctest_FRAMEWORK_DIRS_RELEASE}")

set(doctest_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET doctest_DEPS_TARGET)
    add_library(doctest_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET doctest_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${doctest_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${doctest_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### doctest_DEPS_TARGET to all of them
conan_package_library_targets("${doctest_LIBS_RELEASE}"    # libraries
                              "${doctest_LIB_DIRS_RELEASE}" # package_libdir
                              "${doctest_BIN_DIRS_RELEASE}" # package_bindir
                              "${doctest_LIBRARY_TYPE_RELEASE}"
                              "${doctest_IS_HOST_WINDOWS_RELEASE}"
                              doctest_DEPS_TARGET
                              doctest_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "doctest"    # package_name
                              "${doctest_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${doctest_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${doctest_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${doctest_LIBRARIES_TARGETS}>
                 )

    if("${doctest_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET doctest::doctest
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     doctest_DEPS_TARGET)
    endif()

    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${doctest_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${doctest_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${doctest_LIB_DIRS_RELEASE}>)
    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${doctest_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${doctest_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(doctest_LIBRARIES_RELEASE doctest::doctest)
