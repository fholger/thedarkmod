# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(tracy_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(tracy_FRAMEWORKS_FOUND_RELEASE "${tracy_FRAMEWORKS_RELEASE}" "${tracy_FRAMEWORK_DIRS_RELEASE}")

set(tracy_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET tracy_DEPS_TARGET)
    add_library(tracy_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET tracy_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${tracy_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${tracy_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### tracy_DEPS_TARGET to all of them
conan_package_library_targets("${tracy_LIBS_RELEASE}"    # libraries
                              "${tracy_LIB_DIRS_RELEASE}" # package_libdir
                              "${tracy_BIN_DIRS_RELEASE}" # package_bindir
                              "${tracy_LIBRARY_TYPE_RELEASE}"
                              "${tracy_IS_HOST_WINDOWS_RELEASE}"
                              tracy_DEPS_TARGET
                              tracy_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "tracy"    # package_name
                              "${tracy_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${tracy_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${tracy_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${tracy_LIBRARIES_TARGETS}>
                 )

    if("${tracy_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET tracy::tracy
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     tracy_DEPS_TARGET)
    endif()

    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${tracy_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${tracy_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${tracy_LIB_DIRS_RELEASE}>)
    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${tracy_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${tracy_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(tracy_LIBRARIES_RELEASE tracy::tracy)
