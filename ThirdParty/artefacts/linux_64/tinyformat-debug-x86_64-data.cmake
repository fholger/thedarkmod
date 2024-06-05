########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(tinyformat_COMPONENT_NAMES "")
if(DEFINED tinyformat_FIND_DEPENDENCY_NAMES)
  list(APPEND tinyformat_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES tinyformat_FIND_DEPENDENCY_NAMES)
else()
  set(tinyformat_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(tinyformat_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/tinyformat")
set(tinyformat_BUILD_MODULES_PATHS_DEBUG )


set(tinyformat_INCLUDE_DIRS_DEBUG "${tinyformat_PACKAGE_FOLDER_DEBUG}/include/")
set(tinyformat_RES_DIRS_DEBUG )
set(tinyformat_DEFINITIONS_DEBUG )
set(tinyformat_SHARED_LINK_FLAGS_DEBUG )
set(tinyformat_EXE_LINK_FLAGS_DEBUG )
set(tinyformat_OBJECTS_DEBUG )
set(tinyformat_COMPILE_DEFINITIONS_DEBUG )
set(tinyformat_COMPILE_OPTIONS_C_DEBUG )
set(tinyformat_COMPILE_OPTIONS_CXX_DEBUG )
set(tinyformat_LIB_DIRS_DEBUG )
set(tinyformat_BIN_DIRS_DEBUG )
set(tinyformat_LIBRARY_TYPE_DEBUG UNKNOWN)
set(tinyformat_IS_HOST_WINDOWS_DEBUG 0)
set(tinyformat_LIBS_DEBUG )
set(tinyformat_SYSTEM_LIBS_DEBUG )
set(tinyformat_FRAMEWORK_DIRS_DEBUG )
set(tinyformat_FRAMEWORKS_DEBUG )
set(tinyformat_BUILD_DIRS_DEBUG )
set(tinyformat_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(tinyformat_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${tinyformat_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${tinyformat_COMPILE_OPTIONS_C_DEBUG}>")
set(tinyformat_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${tinyformat_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${tinyformat_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${tinyformat_EXE_LINK_FLAGS_DEBUG}>")


set(tinyformat_COMPONENTS_DEBUG )