########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(zlib_COMPONENT_NAMES "")
if(DEFINED zlib_FIND_DEPENDENCY_NAMES)
  list(APPEND zlib_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES zlib_FIND_DEPENDENCY_NAMES)
else()
  set(zlib_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(zlib_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/zlib")
set(zlib_BUILD_MODULES_PATHS_RELEASE )


set(zlib_INCLUDE_DIRS_RELEASE "${zlib_PACKAGE_FOLDER_RELEASE}/include/windows/")
set(zlib_RES_DIRS_RELEASE )
set(zlib_DEFINITIONS_RELEASE )
set(zlib_SHARED_LINK_FLAGS_RELEASE )
set(zlib_EXE_LINK_FLAGS_RELEASE )
set(zlib_OBJECTS_RELEASE )
set(zlib_COMPILE_DEFINITIONS_RELEASE )
set(zlib_COMPILE_OPTIONS_C_RELEASE )
set(zlib_COMPILE_OPTIONS_CXX_RELEASE )
set(zlib_LIB_DIRS_RELEASE "${zlib_PACKAGE_FOLDER_RELEASE}/lib/windows64_rel/")
set(zlib_BIN_DIRS_RELEASE )
set(zlib_LIBRARY_TYPE_RELEASE STATIC)
set(zlib_IS_HOST_WINDOWS_RELEASE 1)
set(zlib_LIBS_RELEASE zlib)
set(zlib_SYSTEM_LIBS_RELEASE )
set(zlib_FRAMEWORK_DIRS_RELEASE )
set(zlib_FRAMEWORKS_RELEASE )
set(zlib_BUILD_DIRS_RELEASE )
set(zlib_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(zlib_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${zlib_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${zlib_COMPILE_OPTIONS_C_RELEASE}>")
set(zlib_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${zlib_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${zlib_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${zlib_EXE_LINK_FLAGS_RELEASE}>")


set(zlib_COMPONENTS_RELEASE )