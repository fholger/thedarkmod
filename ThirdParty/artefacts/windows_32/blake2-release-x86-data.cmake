########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(blake2_COMPONENT_NAMES "")
if(DEFINED blake2_FIND_DEPENDENCY_NAMES)
  list(APPEND blake2_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES blake2_FIND_DEPENDENCY_NAMES)
else()
  set(blake2_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(blake2_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/blake2")
set(blake2_BUILD_MODULES_PATHS_RELEASE )


set(blake2_INCLUDE_DIRS_RELEASE "${blake2_PACKAGE_FOLDER_RELEASE}/include/"
			"${blake2_PACKAGE_FOLDER_RELEASE}/include/")
set(blake2_RES_DIRS_RELEASE )
set(blake2_DEFINITIONS_RELEASE )
set(blake2_SHARED_LINK_FLAGS_RELEASE )
set(blake2_EXE_LINK_FLAGS_RELEASE )
set(blake2_OBJECTS_RELEASE )
set(blake2_COMPILE_DEFINITIONS_RELEASE )
set(blake2_COMPILE_OPTIONS_C_RELEASE )
set(blake2_COMPILE_OPTIONS_CXX_RELEASE )
set(blake2_LIB_DIRS_RELEASE "${blake2_PACKAGE_FOLDER_RELEASE}/lib/windows32_rel/")
set(blake2_BIN_DIRS_RELEASE )
set(blake2_LIBRARY_TYPE_RELEASE STATIC)
set(blake2_IS_HOST_WINDOWS_RELEASE 1)
set(blake2_LIBS_RELEASE BLAKE2)
set(blake2_SYSTEM_LIBS_RELEASE )
set(blake2_FRAMEWORK_DIRS_RELEASE )
set(blake2_FRAMEWORKS_RELEASE )
set(blake2_BUILD_DIRS_RELEASE )
set(blake2_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(blake2_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${blake2_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${blake2_COMPILE_OPTIONS_C_RELEASE}>")
set(blake2_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${blake2_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${blake2_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${blake2_EXE_LINK_FLAGS_RELEASE}>")


set(blake2_COMPONENTS_RELEASE )