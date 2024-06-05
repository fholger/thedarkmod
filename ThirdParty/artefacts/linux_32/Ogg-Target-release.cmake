# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(ogg_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(ogg_FRAMEWORKS_FOUND_RELEASE "${ogg_FRAMEWORKS_RELEASE}" "${ogg_FRAMEWORK_DIRS_RELEASE}")

set(ogg_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET ogg_DEPS_TARGET)
    add_library(ogg_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET ogg_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${ogg_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${ogg_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### ogg_DEPS_TARGET to all of them
conan_package_library_targets("${ogg_LIBS_RELEASE}"    # libraries
                              "${ogg_LIB_DIRS_RELEASE}" # package_libdir
                              "${ogg_BIN_DIRS_RELEASE}" # package_bindir
                              "${ogg_LIBRARY_TYPE_RELEASE}"
                              "${ogg_IS_HOST_WINDOWS_RELEASE}"
                              ogg_DEPS_TARGET
                              ogg_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "ogg"    # package_name
                              "${ogg_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${ogg_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Release ########################################

    ########## COMPONENT Ogg::ogg #############

        set(ogg_Ogg_ogg_FRAMEWORKS_FOUND_RELEASE "")
        conan_find_apple_frameworks(ogg_Ogg_ogg_FRAMEWORKS_FOUND_RELEASE "${ogg_Ogg_ogg_FRAMEWORKS_RELEASE}" "${ogg_Ogg_ogg_FRAMEWORK_DIRS_RELEASE}")

        set(ogg_Ogg_ogg_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET ogg_Ogg_ogg_DEPS_TARGET)
            add_library(ogg_Ogg_ogg_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET ogg_Ogg_ogg_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${ogg_Ogg_ogg_FRAMEWORKS_FOUND_RELEASE}>
                     $<$<CONFIG:Release>:${ogg_Ogg_ogg_SYSTEM_LIBS_RELEASE}>
                     $<$<CONFIG:Release>:${ogg_Ogg_ogg_DEPENDENCIES_RELEASE}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'ogg_Ogg_ogg_DEPS_TARGET' to all of them
        conan_package_library_targets("${ogg_Ogg_ogg_LIBS_RELEASE}"
                              "${ogg_Ogg_ogg_LIB_DIRS_RELEASE}"
                              "${ogg_Ogg_ogg_BIN_DIRS_RELEASE}" # package_bindir
                              "${ogg_Ogg_ogg_LIBRARY_TYPE_RELEASE}"
                              "${ogg_Ogg_ogg_IS_HOST_WINDOWS_RELEASE}"
                              ogg_Ogg_ogg_DEPS_TARGET
                              ogg_Ogg_ogg_LIBRARIES_TARGETS
                              "_RELEASE"
                              "ogg_Ogg_ogg"
                              "${ogg_Ogg_ogg_NO_SONAME_MODE_RELEASE}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET Ogg::ogg
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${ogg_Ogg_ogg_OBJECTS_RELEASE}>
                     $<$<CONFIG:Release>:${ogg_Ogg_ogg_LIBRARIES_TARGETS}>
                     )

        if("${ogg_Ogg_ogg_LIBS_RELEASE}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET Ogg::ogg
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         ogg_Ogg_ogg_DEPS_TARGET)
        endif()

        set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Release>:${ogg_Ogg_ogg_LINKER_FLAGS_RELEASE}>)
        set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Release>:${ogg_Ogg_ogg_INCLUDE_DIRS_RELEASE}>)
        set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Release>:${ogg_Ogg_ogg_LIB_DIRS_RELEASE}>)
        set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Release>:${ogg_Ogg_ogg_COMPILE_DEFINITIONS_RELEASE}>)
        set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Release>:${ogg_Ogg_ogg_COMPILE_OPTIONS_RELEASE}>)

    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_LINK_LIBRARIES Ogg::ogg)

########## For the modules (FindXXX)
set(ogg_LIBRARIES_RELEASE Ogg::ogg)
