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
set(blake2_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/blake2")
set(blake2_BUILD_MODULES_PATHS_DEBUG )


set(blake2_INCLUDE_DIRS_DEBUG "${blake2_PACKAGE_FOLDER_DEBUG}/include/"
			"${blake2_PACKAGE_FOLDER_DEBUG}/include/")
set(blake2_RES_DIRS_DEBUG )
set(blake2_DEFINITIONS_DEBUG )
set(blake2_SHARED_LINK_FLAGS_DEBUG )
set(blake2_EXE_LINK_FLAGS_DEBUG )
set(blake2_OBJECTS_DEBUG )
set(blake2_COMPILE_DEFINITIONS_DEBUG )
set(blake2_COMPILE_OPTIONS_C_DEBUG )
set(blake2_COMPILE_OPTIONS_CXX_DEBUG )
set(blake2_LIB_DIRS_DEBUG "${blake2_PACKAGE_FOLDER_DEBUG}/lib/windows64_rel/")
set(blake2_BIN_DIRS_DEBUG )
set(blake2_LIBRARY_TYPE_DEBUG STATIC)
set(blake2_IS_HOST_WINDOWS_DEBUG 1)
set(blake2_LIBS_DEBUG BLAKE2)
set(blake2_SYSTEM_LIBS_DEBUG )
set(blake2_FRAMEWORK_DIRS_DEBUG )
set(blake2_FRAMEWORKS_DEBUG )
set(blake2_BUILD_DIRS_DEBUG )
set(blake2_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(blake2_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${blake2_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${blake2_COMPILE_OPTIONS_C_DEBUG}>")
set(blake2_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${blake2_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${blake2_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${blake2_EXE_LINK_FLAGS_DEBUG}>")


set(blake2_COMPONENTS_DEBUG )