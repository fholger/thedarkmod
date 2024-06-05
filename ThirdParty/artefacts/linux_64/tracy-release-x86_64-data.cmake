########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(tracy_COMPONENT_NAMES "")
if(DEFINED tracy_FIND_DEPENDENCY_NAMES)
  list(APPEND tracy_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES tracy_FIND_DEPENDENCY_NAMES)
else()
  set(tracy_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(tracy_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/tracy")
set(tracy_BUILD_MODULES_PATHS_RELEASE )


set(tracy_INCLUDE_DIRS_RELEASE "${tracy_PACKAGE_FOLDER_RELEASE}/include/")
set(tracy_RES_DIRS_RELEASE )
set(tracy_DEFINITIONS_RELEASE )
set(tracy_SHARED_LINK_FLAGS_RELEASE )
set(tracy_EXE_LINK_FLAGS_RELEASE )
set(tracy_OBJECTS_RELEASE )
set(tracy_COMPILE_DEFINITIONS_RELEASE )
set(tracy_COMPILE_OPTIONS_C_RELEASE )
set(tracy_COMPILE_OPTIONS_CXX_RELEASE )
set(tracy_LIB_DIRS_RELEASE "${tracy_PACKAGE_FOLDER_RELEASE}/lib")
set(tracy_BIN_DIRS_RELEASE )
set(tracy_LIBRARY_TYPE_RELEASE UNKNOWN)
set(tracy_IS_HOST_WINDOWS_RELEASE 0)
set(tracy_LIBS_RELEASE )
set(tracy_SYSTEM_LIBS_RELEASE )
set(tracy_FRAMEWORK_DIRS_RELEASE )
set(tracy_FRAMEWORKS_RELEASE )
set(tracy_BUILD_DIRS_RELEASE )
set(tracy_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(tracy_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${tracy_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${tracy_COMPILE_OPTIONS_C_RELEASE}>")
set(tracy_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${tracy_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${tracy_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${tracy_EXE_LINK_FLAGS_RELEASE}>")


set(tracy_COMPONENTS_RELEASE )