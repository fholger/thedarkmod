# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(libalsa_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(libalsa_FRAMEWORKS_FOUND_RELEASE "${libalsa_FRAMEWORKS_RELEASE}" "${libalsa_FRAMEWORK_DIRS_RELEASE}")

set(libalsa_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET libalsa_DEPS_TARGET)
    add_library(libalsa_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET libalsa_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${libalsa_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${libalsa_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### libalsa_DEPS_TARGET to all of them
conan_package_library_targets("${libalsa_LIBS_RELEASE}"    # libraries
                              "${libalsa_LIB_DIRS_RELEASE}" # package_libdir
                              "${libalsa_BIN_DIRS_RELEASE}" # package_bindir
                              "${libalsa_LIBRARY_TYPE_RELEASE}"
                              "${libalsa_IS_HOST_WINDOWS_RELEASE}"
                              libalsa_DEPS_TARGET
                              libalsa_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "libalsa"    # package_name
                              "${libalsa_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${libalsa_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET ALSA::ALSA
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${libalsa_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${libalsa_LIBRARIES_TARGETS}>
                 )

    if("${libalsa_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET ALSA::ALSA
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     libalsa_DEPS_TARGET)
    endif()

    set_property(TARGET ALSA::ALSA
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${libalsa_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET ALSA::ALSA
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${libalsa_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET ALSA::ALSA
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${libalsa_LIB_DIRS_RELEASE}>)
    set_property(TARGET ALSA::ALSA
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${libalsa_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET ALSA::ALSA
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${libalsa_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(libalsa_LIBRARIES_RELEASE ALSA::ALSA)
