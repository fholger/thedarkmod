########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND ogg_COMPONENT_NAMES Ogg::ogg)
list(REMOVE_DUPLICATES ogg_COMPONENT_NAMES)
if(DEFINED ogg_FIND_DEPENDENCY_NAMES)
  list(APPEND ogg_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES ogg_FIND_DEPENDENCY_NAMES)
else()
  set(ogg_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(ogg_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/ogg")
set(ogg_BUILD_MODULES_PATHS_DEBUG )


set(ogg_INCLUDE_DIRS_DEBUG "${ogg_PACKAGE_FOLDER_DEBUG}/include/")
set(ogg_RES_DIRS_DEBUG )
set(ogg_DEFINITIONS_DEBUG )
set(ogg_SHARED_LINK_FLAGS_DEBUG )
set(ogg_EXE_LINK_FLAGS_DEBUG )
set(ogg_OBJECTS_DEBUG )
set(ogg_COMPILE_DEFINITIONS_DEBUG )
set(ogg_COMPILE_OPTIONS_C_DEBUG )
set(ogg_COMPILE_OPTIONS_CXX_DEBUG )
set(ogg_LIB_DIRS_DEBUG "${ogg_PACKAGE_FOLDER_DEBUG}/lib/windows32_rel/")
set(ogg_BIN_DIRS_DEBUG )
set(ogg_LIBRARY_TYPE_DEBUG STATIC)
set(ogg_IS_HOST_WINDOWS_DEBUG 1)
set(ogg_LIBS_DEBUG ogg)
set(ogg_SYSTEM_LIBS_DEBUG )
set(ogg_FRAMEWORK_DIRS_DEBUG )
set(ogg_FRAMEWORKS_DEBUG )
set(ogg_BUILD_DIRS_DEBUG )
set(ogg_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(ogg_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${ogg_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${ogg_COMPILE_OPTIONS_C_DEBUG}>")
set(ogg_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${ogg_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${ogg_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${ogg_EXE_LINK_FLAGS_DEBUG}>")


set(ogg_COMPONENTS_DEBUG Ogg::ogg)
########### COMPONENT Ogg::ogg VARIABLES ############################################

set(ogg_Ogg_ogg_INCLUDE_DIRS_DEBUG "${ogg_PACKAGE_FOLDER_DEBUG}/include/")
set(ogg_Ogg_ogg_LIB_DIRS_DEBUG "${ogg_PACKAGE_FOLDER_DEBUG}/lib/windows32_rel/")
set(ogg_Ogg_ogg_BIN_DIRS_DEBUG )
set(ogg_Ogg_ogg_LIBRARY_TYPE_DEBUG STATIC)
set(ogg_Ogg_ogg_IS_HOST_WINDOWS_DEBUG 1)
set(ogg_Ogg_ogg_RES_DIRS_DEBUG )
set(ogg_Ogg_ogg_DEFINITIONS_DEBUG )
set(ogg_Ogg_ogg_OBJECTS_DEBUG )
set(ogg_Ogg_ogg_COMPILE_DEFINITIONS_DEBUG )
set(ogg_Ogg_ogg_COMPILE_OPTIONS_C_DEBUG "")
set(ogg_Ogg_ogg_COMPILE_OPTIONS_CXX_DEBUG "")
set(ogg_Ogg_ogg_LIBS_DEBUG ogg)
set(ogg_Ogg_ogg_SYSTEM_LIBS_DEBUG )
set(ogg_Ogg_ogg_FRAMEWORK_DIRS_DEBUG )
set(ogg_Ogg_ogg_FRAMEWORKS_DEBUG )
set(ogg_Ogg_ogg_DEPENDENCIES_DEBUG )
set(ogg_Ogg_ogg_SHARED_LINK_FLAGS_DEBUG )
set(ogg_Ogg_ogg_EXE_LINK_FLAGS_DEBUG )
set(ogg_Ogg_ogg_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(ogg_Ogg_ogg_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${ogg_Ogg_ogg_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${ogg_Ogg_ogg_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${ogg_Ogg_ogg_EXE_LINK_FLAGS_DEBUG}>
)
set(ogg_Ogg_ogg_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${ogg_Ogg_ogg_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${ogg_Ogg_ogg_COMPILE_OPTIONS_C_DEBUG}>")