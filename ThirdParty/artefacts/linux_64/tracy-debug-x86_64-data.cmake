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
set(tracy_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/tracy")
set(tracy_BUILD_MODULES_PATHS_DEBUG )


set(tracy_INCLUDE_DIRS_DEBUG "${tracy_PACKAGE_FOLDER_DEBUG}/include/")
set(tracy_RES_DIRS_DEBUG )
set(tracy_DEFINITIONS_DEBUG )
set(tracy_SHARED_LINK_FLAGS_DEBUG )
set(tracy_EXE_LINK_FLAGS_DEBUG )
set(tracy_OBJECTS_DEBUG )
set(tracy_COMPILE_DEFINITIONS_DEBUG )
set(tracy_COMPILE_OPTIONS_C_DEBUG )
set(tracy_COMPILE_OPTIONS_CXX_DEBUG )
set(tracy_LIB_DIRS_DEBUG "${tracy_PACKAGE_FOLDER_DEBUG}/lib")
set(tracy_BIN_DIRS_DEBUG )
set(tracy_LIBRARY_TYPE_DEBUG UNKNOWN)
set(tracy_IS_HOST_WINDOWS_DEBUG 0)
set(tracy_LIBS_DEBUG )
set(tracy_SYSTEM_LIBS_DEBUG )
set(tracy_FRAMEWORK_DIRS_DEBUG )
set(tracy_FRAMEWORKS_DEBUG )
set(tracy_BUILD_DIRS_DEBUG )
set(tracy_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(tracy_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${tracy_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${tracy_COMPILE_OPTIONS_C_DEBUG}>")
set(tracy_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${tracy_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${tracy_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${tracy_EXE_LINK_FLAGS_DEBUG}>")


set(tracy_COMPONENTS_DEBUG )