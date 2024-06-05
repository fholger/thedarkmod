# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(glfw_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(glfw_FRAMEWORKS_FOUND_RELEASE "${glfw_FRAMEWORKS_RELEASE}" "${glfw_FRAMEWORK_DIRS_RELEASE}")

set(glfw_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET glfw_DEPS_TARGET)
    add_library(glfw_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET glfw_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${glfw_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${glfw_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:opengl::opengl>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### glfw_DEPS_TARGET to all of them
conan_package_library_targets("${glfw_LIBS_RELEASE}"    # libraries
                              "${glfw_LIB_DIRS_RELEASE}" # package_libdir
                              "${glfw_BIN_DIRS_RELEASE}" # package_bindir
                              "${glfw_LIBRARY_TYPE_RELEASE}"
                              "${glfw_IS_HOST_WINDOWS_RELEASE}"
                              glfw_DEPS_TARGET
                              glfw_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "glfw"    # package_name
                              "${glfw_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${glfw_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET glfw
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${glfw_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${glfw_LIBRARIES_TARGETS}>
                 )

    if("${glfw_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET glfw
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     glfw_DEPS_TARGET)
    endif()

    set_property(TARGET glfw
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${glfw_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET glfw
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${glfw_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET glfw
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${glfw_LIB_DIRS_RELEASE}>)
    set_property(TARGET glfw
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${glfw_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET glfw
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${glfw_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(glfw_LIBRARIES_RELEASE glfw)
