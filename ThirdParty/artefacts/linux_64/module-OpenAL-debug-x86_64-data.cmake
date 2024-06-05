########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(openal_COMPONENT_NAMES "")
if(DEFINED openal_FIND_DEPENDENCY_NAMES)
  list(APPEND openal_FIND_DEPENDENCY_NAMES ALSA)
  list(REMOVE_DUPLICATES openal_FIND_DEPENDENCY_NAMES)
else()
  set(openal_FIND_DEPENDENCY_NAMES ALSA)
endif()
set(ALSA_FIND_MODE "MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(openal_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/openal")
set(openal_BUILD_MODULES_PATHS_DEBUG )


set(openal_INCLUDE_DIRS_DEBUG "${openal_PACKAGE_FOLDER_DEBUG}/include/"
			"${openal_PACKAGE_FOLDER_DEBUG}/include/AL")
set(openal_RES_DIRS_DEBUG )
set(openal_DEFINITIONS_DEBUG "-DAL_LIBTYPE_STATIC")
set(openal_SHARED_LINK_FLAGS_DEBUG )
set(openal_EXE_LINK_FLAGS_DEBUG )
set(openal_OBJECTS_DEBUG )
set(openal_COMPILE_DEFINITIONS_DEBUG "AL_LIBTYPE_STATIC")
set(openal_COMPILE_OPTIONS_C_DEBUG )
set(openal_COMPILE_OPTIONS_CXX_DEBUG )
set(openal_LIB_DIRS_DEBUG "${openal_PACKAGE_FOLDER_DEBUG}/lib/linux64_rel/")
set(openal_BIN_DIRS_DEBUG )
set(openal_LIBRARY_TYPE_DEBUG STATIC)
set(openal_IS_HOST_WINDOWS_DEBUG 0)
set(openal_LIBS_DEBUG openal)
set(openal_SYSTEM_LIBS_DEBUG dl m stdc++)
set(openal_FRAMEWORK_DIRS_DEBUG )
set(openal_FRAMEWORKS_DEBUG )
set(openal_BUILD_DIRS_DEBUG )
set(openal_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(openal_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${openal_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${openal_COMPILE_OPTIONS_C_DEBUG}>")
set(openal_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${openal_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${openal_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${openal_EXE_LINK_FLAGS_DEBUG}>")


set(openal_COMPONENTS_DEBUG )