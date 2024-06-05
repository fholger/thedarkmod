# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(pugixml_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(pugixml_FRAMEWORKS_FOUND_DEBUG "${pugixml_FRAMEWORKS_DEBUG}" "${pugixml_FRAMEWORK_DIRS_DEBUG}")

set(pugixml_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET pugixml_DEPS_TARGET)
    add_library(pugixml_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET pugixml_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${pugixml_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${pugixml_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### pugixml_DEPS_TARGET to all of them
conan_package_library_targets("${pugixml_LIBS_DEBUG}"    # libraries
                              "${pugixml_LIB_DIRS_DEBUG}" # package_libdir
                              "${pugixml_BIN_DIRS_DEBUG}" # package_bindir
                              "${pugixml_LIBRARY_TYPE_DEBUG}"
                              "${pugixml_IS_HOST_WINDOWS_DEBUG}"
                              pugixml_DEPS_TARGET
                              pugixml_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "pugixml"    # package_name
                              "${pugixml_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${pugixml_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Debug ########################################
    set_property(TARGET pugixml::pugixml
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Debug>:${pugixml_OBJECTS_DEBUG}>
                 $<$<CONFIG:Debug>:${pugixml_LIBRARIES_TARGETS}>
                 )

    if("${pugixml_LIBS_DEBUG}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET pugixml::pugixml
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     pugixml_DEPS_TARGET)
    endif()

    set_property(TARGET pugixml::pugixml
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Debug>:${pugixml_LINKER_FLAGS_DEBUG}>)
    set_property(TARGET pugixml::pugixml
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Debug>:${pugixml_INCLUDE_DIRS_DEBUG}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET pugixml::pugixml
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Debug>:${pugixml_LIB_DIRS_DEBUG}>)
    set_property(TARGET pugixml::pugixml
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Debug>:${pugixml_COMPILE_DEFINITIONS_DEBUG}>)
    set_property(TARGET pugixml::pugixml
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Debug>:${pugixml_COMPILE_OPTIONS_DEBUG}>)

########## For the modules (FindXXX)
set(pugixml_LIBRARIES_DEBUG pugixml::pugixml)
