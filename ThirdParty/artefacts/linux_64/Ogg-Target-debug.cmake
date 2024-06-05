# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(ogg_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(ogg_FRAMEWORKS_FOUND_DEBUG "${ogg_FRAMEWORKS_DEBUG}" "${ogg_FRAMEWORK_DIRS_DEBUG}")

set(ogg_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET ogg_DEPS_TARGET)
    add_library(ogg_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET ogg_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${ogg_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${ogg_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### ogg_DEPS_TARGET to all of them
conan_package_library_targets("${ogg_LIBS_DEBUG}"    # libraries
                              "${ogg_LIB_DIRS_DEBUG}" # package_libdir
                              "${ogg_BIN_DIRS_DEBUG}" # package_bindir
                              "${ogg_LIBRARY_TYPE_DEBUG}"
                              "${ogg_IS_HOST_WINDOWS_DEBUG}"
                              ogg_DEPS_TARGET
                              ogg_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "ogg"    # package_name
                              "${ogg_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${ogg_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Debug ########################################

    ########## COMPONENT Ogg::ogg #############

        set(ogg_Ogg_ogg_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(ogg_Ogg_ogg_FRAMEWORKS_FOUND_DEBUG "${ogg_Ogg_ogg_FRAMEWORKS_DEBUG}" "${ogg_Ogg_ogg_FRAMEWORK_DIRS_DEBUG}")

        set(ogg_Ogg_ogg_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET ogg_Ogg_ogg_DEPS_TARGET)
            add_library(ogg_Ogg_ogg_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET ogg_Ogg_ogg_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ogg_Ogg_ogg_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${ogg_Ogg_ogg_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${ogg_Ogg_ogg_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'ogg_Ogg_ogg_DEPS_TARGET' to all of them
        conan_package_library_targets("${ogg_Ogg_ogg_LIBS_DEBUG}"
                              "${ogg_Ogg_ogg_LIB_DIRS_DEBUG}"
                              "${ogg_Ogg_ogg_BIN_DIRS_DEBUG}" # package_bindir
                              "${ogg_Ogg_ogg_LIBRARY_TYPE_DEBUG}"
                              "${ogg_Ogg_ogg_IS_HOST_WINDOWS_DEBUG}"
                              ogg_Ogg_ogg_DEPS_TARGET
                              ogg_Ogg_ogg_LIBRARIES_TARGETS
                              "_DEBUG"
                              "ogg_Ogg_ogg"
                              "${ogg_Ogg_ogg_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET Ogg::ogg
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ogg_Ogg_ogg_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${ogg_Ogg_ogg_LIBRARIES_TARGETS}>
                     )

        if("${ogg_Ogg_ogg_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET Ogg::ogg
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         ogg_Ogg_ogg_DEPS_TARGET)
        endif()

        set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${ogg_Ogg_ogg_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${ogg_Ogg_ogg_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${ogg_Ogg_ogg_LIB_DIRS_DEBUG}>)
        set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${ogg_Ogg_ogg_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${ogg_Ogg_ogg_COMPILE_OPTIONS_DEBUG}>)

    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET Ogg::ogg APPEND PROPERTY INTERFACE_LINK_LIBRARIES Ogg::ogg)

########## For the modules (FindXXX)
set(ogg_LIBRARIES_DEBUG Ogg::ogg)
