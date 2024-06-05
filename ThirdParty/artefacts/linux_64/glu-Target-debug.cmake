# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(glu_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(glu_FRAMEWORKS_FOUND_DEBUG "${glu_FRAMEWORKS_DEBUG}" "${glu_FRAMEWORK_DIRS_DEBUG}")

set(glu_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET glu_DEPS_TARGET)
    add_library(glu_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET glu_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${glu_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${glu_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:opengl::opengl>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### glu_DEPS_TARGET to all of them
conan_package_library_targets("${glu_LIBS_DEBUG}"    # libraries
                              "${glu_LIB_DIRS_DEBUG}" # package_libdir
                              "${glu_BIN_DIRS_DEBUG}" # package_bindir
                              "${glu_LIBRARY_TYPE_DEBUG}"
                              "${glu_IS_HOST_WINDOWS_DEBUG}"
                              glu_DEPS_TARGET
                              glu_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "glu"    # package_name
                              "${glu_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${glu_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET glu::glu
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${glu_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${glu_LIBRARIES_TARGETS}>
                 )

    if("${glu_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET glu::glu
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     glu_DEPS_TARGET)
    endif()

    set_property(TARGET glu::glu
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${glu_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET glu::glu
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${glu_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET glu::glu
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${glu_LIB_DIRS_DEBUG}>)
    set_property(TARGET glu::glu
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${glu_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET glu::glu
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${glu_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(glu_LIBRARIES_DEBUG glu::glu)
