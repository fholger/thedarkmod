########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(openal_COMPONENT_NAMES "")
if(DEFINED openal_FIND_DEPENDENCY_NAMES)
  list(APPEND openal_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES openal_FIND_DEPENDENCY_NAMES)
else()
  set(openal_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(openal_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/openal")
set(openal_BUILD_MODULES_PATHS_RELEASE )


set(openal_INCLUDE_DIRS_RELEASE "${openal_PACKAGE_FOLDER_RELEASE}/include/"
			"${openal_PACKAGE_FOLDER_RELEASE}/include/AL")
set(openal_RES_DIRS_RELEASE )
set(openal_DEFINITIONS_RELEASE "-DAL_LIBTYPE_STATIC")
set(openal_SHARED_LINK_FLAGS_RELEASE )
set(openal_EXE_LINK_FLAGS_RELEASE )
set(openal_OBJECTS_RELEASE )
set(openal_COMPILE_DEFINITIONS_RELEASE "AL_LIBTYPE_STATIC")
set(openal_COMPILE_OPTIONS_C_RELEASE )
set(openal_COMPILE_OPTIONS_CXX_RELEASE )
set(openal_LIB_DIRS_RELEASE "${openal_PACKAGE_FOLDER_RELEASE}/lib/windows64_rel/")
set(openal_BIN_DIRS_RELEASE )
set(openal_LIBRARY_TYPE_RELEASE STATIC)
set(openal_IS_HOST_WINDOWS_RELEASE 1)
set(openal_LIBS_RELEASE OpenAL32)
set(openal_SYSTEM_LIBS_RELEASE winmm ole32 shell32 user32)
set(openal_FRAMEWORK_DIRS_RELEASE )
set(openal_FRAMEWORKS_RELEASE )
set(openal_BUILD_DIRS_RELEASE )
set(openal_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(openal_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${openal_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${openal_COMPILE_OPTIONS_C_RELEASE}>")
set(openal_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${openal_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${openal_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${openal_EXE_LINK_FLAGS_RELEASE}>")


set(openal_COMPONENTS_RELEASE )