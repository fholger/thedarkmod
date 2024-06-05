########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(minizip_COMPONENT_NAMES "")
if(DEFINED minizip_FIND_DEPENDENCY_NAMES)
  list(APPEND minizip_FIND_DEPENDENCY_NAMES ZLIB)
  list(REMOVE_DUPLICATES minizip_FIND_DEPENDENCY_NAMES)
else()
  set(minizip_FIND_DEPENDENCY_NAMES ZLIB)
endif()
set(ZLIB_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(minizip_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/minizip")
set(minizip_BUILD_MODULES_PATHS_RELEASE )


set(minizip_INCLUDE_DIRS_RELEASE "${minizip_PACKAGE_FOLDER_RELEASE}/include/"
			"${minizip_PACKAGE_FOLDER_RELEASE}/include/minizip")
set(minizip_RES_DIRS_RELEASE )
set(minizip_DEFINITIONS_RELEASE )
set(minizip_SHARED_LINK_FLAGS_RELEASE )
set(minizip_EXE_LINK_FLAGS_RELEASE )
set(minizip_OBJECTS_RELEASE )
set(minizip_COMPILE_DEFINITIONS_RELEASE )
set(minizip_COMPILE_OPTIONS_C_RELEASE )
set(minizip_COMPILE_OPTIONS_CXX_RELEASE )
set(minizip_LIB_DIRS_RELEASE "${minizip_PACKAGE_FOLDER_RELEASE}/lib/windows32_rel/")
set(minizip_BIN_DIRS_RELEASE )
set(minizip_LIBRARY_TYPE_RELEASE STATIC)
set(minizip_IS_HOST_WINDOWS_RELEASE 1)
set(minizip_LIBS_RELEASE minizip)
set(minizip_SYSTEM_LIBS_RELEASE )
set(minizip_FRAMEWORK_DIRS_RELEASE )
set(minizip_FRAMEWORKS_RELEASE )
set(minizip_BUILD_DIRS_RELEASE )
set(minizip_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(minizip_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${minizip_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${minizip_COMPILE_OPTIONS_C_RELEASE}>")
set(minizip_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${minizip_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${minizip_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${minizip_EXE_LINK_FLAGS_RELEASE}>")


set(minizip_COMPONENTS_RELEASE )