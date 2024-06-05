########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(doctest_COMPONENT_NAMES "")
if(DEFINED doctest_FIND_DEPENDENCY_NAMES)
  list(APPEND doctest_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES doctest_FIND_DEPENDENCY_NAMES)
else()
  set(doctest_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(doctest_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/doctest")
set(doctest_BUILD_MODULES_PATHS_DEBUG )


set(doctest_INCLUDE_DIRS_DEBUG "${doctest_PACKAGE_FOLDER_DEBUG}/include/")
set(doctest_RES_DIRS_DEBUG )
set(doctest_DEFINITIONS_DEBUG )
set(doctest_SHARED_LINK_FLAGS_DEBUG )
set(doctest_EXE_LINK_FLAGS_DEBUG )
set(doctest_OBJECTS_DEBUG )
set(doctest_COMPILE_DEFINITIONS_DEBUG )
set(doctest_COMPILE_OPTIONS_C_DEBUG )
set(doctest_COMPILE_OPTIONS_CXX_DEBUG )
set(doctest_LIB_DIRS_DEBUG )
set(doctest_BIN_DIRS_DEBUG )
set(doctest_LIBRARY_TYPE_DEBUG UNKNOWN)
set(doctest_IS_HOST_WINDOWS_DEBUG 0)
set(doctest_LIBS_DEBUG )
set(doctest_SYSTEM_LIBS_DEBUG )
set(doctest_FRAMEWORK_DIRS_DEBUG )
set(doctest_FRAMEWORKS_DEBUG )
set(doctest_BUILD_DIRS_DEBUG "${doctest_PACKAGE_FOLDER_DEBUG}/lib/cmake")
set(doctest_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(doctest_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${doctest_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${doctest_COMPILE_OPTIONS_C_DEBUG}>")
set(doctest_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${doctest_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${doctest_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${doctest_EXE_LINK_FLAGS_DEBUG}>")


set(doctest_COMPONENTS_DEBUG )