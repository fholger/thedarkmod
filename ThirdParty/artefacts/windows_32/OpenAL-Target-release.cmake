# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(openal_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(openal_FRAMEWORKS_FOUND_RELEASE "${openal_FRAMEWORKS_RELEASE}" "${openal_FRAMEWORK_DIRS_RELEASE}")

set(openal_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET openal_DEPS_TARGET)
    add_library(openal_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET openal_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${openal_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${openal_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### openal_DEPS_TARGET to all of them
conan_package_library_targets("${openal_LIBS_RELEASE}"    # libraries
                              "${openal_LIB_DIRS_RELEASE}" # package_libdir
                              "${openal_BIN_DIRS_RELEASE}" # package_bindir
                              "${openal_LIBRARY_TYPE_RELEASE}"
                              "${openal_IS_HOST_WINDOWS_RELEASE}"
                              openal_DEPS_TARGET
                              openal_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "openal"    # package_name
                              "${openal_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${openal_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${openal_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${openal_LIBRARIES_TARGETS}>
                 )

    if("${openal_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET OpenAL::OpenAL
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     openal_DEPS_TARGET)
    endif()

    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${openal_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${openal_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${openal_LIB_DIRS_RELEASE}>)
    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${openal_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${openal_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(openal_LIBRARIES_RELEASE OpenAL::OpenAL)
