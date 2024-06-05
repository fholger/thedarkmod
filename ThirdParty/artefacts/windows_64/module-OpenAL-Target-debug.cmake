# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(openal_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(openal_FRAMEWORKS_FOUND_DEBUG "${openal_FRAMEWORKS_DEBUG}" "${openal_FRAMEWORK_DIRS_DEBUG}")

set(openal_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET openal_DEPS_TARGET)
    add_library(openal_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET openal_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${openal_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${openal_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### openal_DEPS_TARGET to all of them
conan_package_library_targets("${openal_LIBS_DEBUG}"    # libraries
                              "${openal_LIB_DIRS_DEBUG}" # package_libdir
                              "${openal_BIN_DIRS_DEBUG}" # package_bindir
                              "${openal_LIBRARY_TYPE_DEBUG}"
                              "${openal_IS_HOST_WINDOWS_DEBUG}"
                              openal_DEPS_TARGET
                              openal_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "openal"    # package_name
                              "${openal_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${openal_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${openal_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${openal_LIBRARIES_TARGETS}>
                 )

    if("${openal_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET OpenAL::OpenAL
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     openal_DEPS_TARGET)
    endif()

    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${openal_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${openal_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${openal_LIB_DIRS_DEBUG}>)
    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${openal_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET OpenAL::OpenAL
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${openal_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(openal_LIBRARIES_DEBUG OpenAL::OpenAL)
