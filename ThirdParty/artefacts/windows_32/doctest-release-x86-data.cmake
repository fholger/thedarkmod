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
set(doctest_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/doctest")
set(doctest_BUILD_MODULES_PATHS_RELEASE )


set(doctest_INCLUDE_DIRS_RELEASE "${doctest_PACKAGE_FOLDER_RELEASE}/include/")
set(doctest_RES_DIRS_RELEASE )
set(doctest_DEFINITIONS_RELEASE )
set(doctest_SHARED_LINK_FLAGS_RELEASE )
set(doctest_EXE_LINK_FLAGS_RELEASE )
set(doctest_OBJECTS_RELEASE )
set(doctest_COMPILE_DEFINITIONS_RELEASE )
set(doctest_COMPILE_OPTIONS_C_RELEASE )
set(doctest_COMPILE_OPTIONS_CXX_RELEASE )
set(doctest_LIB_DIRS_RELEASE )
set(doctest_BIN_DIRS_RELEASE )
set(doctest_LIBRARY_TYPE_RELEASE UNKNOWN)
set(doctest_IS_HOST_WINDOWS_RELEASE 1)
set(doctest_LIBS_RELEASE )
set(doctest_SYSTEM_LIBS_RELEASE )
set(doctest_FRAMEWORK_DIRS_RELEASE )
set(doctest_FRAMEWORKS_RELEASE )
set(doctest_BUILD_DIRS_RELEASE "${doctest_PACKAGE_FOLDER_RELEASE}/lib/cmake")
set(doctest_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(doctest_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${doctest_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${doctest_COMPILE_OPTIONS_C_RELEASE}>")
set(doctest_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${doctest_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${doctest_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${doctest_EXE_LINK_FLAGS_RELEASE}>")


set(doctest_COMPONENTS_RELEASE )