# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(doctest_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(doctest_FRAMEWORKS_FOUND_DEBUG "${doctest_FRAMEWORKS_DEBUG}" "${doctest_FRAMEWORK_DIRS_DEBUG}")

set(doctest_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET doctest_DEPS_TARGET)
    add_library(doctest_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET doctest_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${doctest_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${doctest_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### doctest_DEPS_TARGET to all of them
conan_package_library_targets("${doctest_LIBS_DEBUG}"    # libraries
                              "${doctest_LIB_DIRS_DEBUG}" # package_libdir
                              "${doctest_BIN_DIRS_DEBUG}" # package_bindir
                              "${doctest_LIBRARY_TYPE_DEBUG}"
                              "${doctest_IS_HOST_WINDOWS_DEBUG}"
                              doctest_DEPS_TARGET
                              doctest_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "doctest"    # package_name
                              "${doctest_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${doctest_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${doctest_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${doctest_LIBRARIES_TARGETS}>
                 )

    if("${doctest_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET doctest::doctest
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     doctest_DEPS_TARGET)
    endif()

    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${doctest_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${doctest_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${doctest_LIB_DIRS_DEBUG}>)
    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${doctest_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET doctest::doctest
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${doctest_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(doctest_LIBRARIES_DEBUG doctest::doctest)
