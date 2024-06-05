# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(tracy_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(tracy_FRAMEWORKS_FOUND_DEBUG "${tracy_FRAMEWORKS_DEBUG}" "${tracy_FRAMEWORK_DIRS_DEBUG}")

set(tracy_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET tracy_DEPS_TARGET)
    add_library(tracy_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET tracy_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${tracy_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${tracy_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### tracy_DEPS_TARGET to all of them
conan_package_library_targets("${tracy_LIBS_DEBUG}"    # libraries
                              "${tracy_LIB_DIRS_DEBUG}" # package_libdir
                              "${tracy_BIN_DIRS_DEBUG}" # package_bindir
                              "${tracy_LIBRARY_TYPE_DEBUG}"
                              "${tracy_IS_HOST_WINDOWS_DEBUG}"
                              tracy_DEPS_TARGET
                              tracy_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "tracy"    # package_name
                              "${tracy_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${tracy_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${tracy_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${tracy_LIBRARIES_TARGETS}>
                 )

    if("${tracy_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET tracy::tracy
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     tracy_DEPS_TARGET)
    endif()

    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${tracy_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${tracy_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${tracy_LIB_DIRS_DEBUG}>)
    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${tracy_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET tracy::tracy
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${tracy_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(tracy_LIBRARIES_DEBUG tracy::tracy)
