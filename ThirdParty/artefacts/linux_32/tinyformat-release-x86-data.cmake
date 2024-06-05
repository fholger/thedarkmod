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
set(tinyformat_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/tinyformat")
set(tinyformat_BUILD_MODULES_PATHS_RELEASE )


set(tinyformat_INCLUDE_DIRS_RELEASE "${tinyformat_PACKAGE_FOLDER_RELEASE}/include/")
set(tinyformat_RES_DIRS_RELEASE )
set(tinyformat_DEFINITIONS_RELEASE )
set(tinyformat_SHARED_LINK_FLAGS_RELEASE )
set(tinyformat_EXE_LINK_FLAGS_RELEASE )
set(tinyformat_OBJECTS_RELEASE )
set(tinyformat_COMPILE_DEFINITIONS_RELEASE )
set(tinyformat_COMPILE_OPTIONS_C_RELEASE )
set(tinyformat_COMPILE_OPTIONS_CXX_RELEASE )
set(tinyformat_LIB_DIRS_RELEASE )
set(tinyformat_BIN_DIRS_RELEASE )
set(tinyformat_LIBRARY_TYPE_RELEASE UNKNOWN)
set(tinyformat_IS_HOST_WINDOWS_RELEASE 0)
set(tinyformat_LIBS_RELEASE )
set(tinyformat_SYSTEM_LIBS_RELEASE )
set(tinyformat_FRAMEWORK_DIRS_RELEASE )
set(tinyformat_FRAMEWORKS_RELEASE )
set(tinyformat_BUILD_DIRS_RELEASE )
set(tinyformat_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(tinyformat_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${tinyformat_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${tinyformat_COMPILE_OPTIONS_C_RELEASE}>")
set(tinyformat_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${tinyformat_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${tinyformat_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${tinyformat_EXE_LINK_FLAGS_RELEASE}>")


set(tinyformat_COMPONENTS_RELEASE )