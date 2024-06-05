########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(libjpeg_COMPONENT_NAMES "")
if(DEFINED libjpeg_FIND_DEPENDENCY_NAMES)
  list(APPEND libjpeg_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES libjpeg_FIND_DEPENDENCY_NAMES)
else()
  set(libjpeg_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(libjpeg_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/libjpeg")
set(libjpeg_BUILD_MODULES_PATHS_DEBUG )


set(libjpeg_INCLUDE_DIRS_DEBUG "${libjpeg_PACKAGE_FOLDER_DEBUG}/include/linux/")
set(libjpeg_RES_DIRS_DEBUG "${libjpeg_PACKAGE_FOLDER_DEBUG}/res")
set(libjpeg_DEFINITIONS_DEBUG "-DLIBJPEG_STATIC")
set(libjpeg_SHARED_LINK_FLAGS_DEBUG )
set(libjpeg_EXE_LINK_FLAGS_DEBUG )
set(libjpeg_OBJECTS_DEBUG )
set(libjpeg_COMPILE_DEFINITIONS_DEBUG "LIBJPEG_STATIC")
set(libjpeg_COMPILE_OPTIONS_C_DEBUG )
set(libjpeg_COMPILE_OPTIONS_CXX_DEBUG )
set(libjpeg_LIB_DIRS_DEBUG "${libjpeg_PACKAGE_FOLDER_DEBUG}/lib/linux32_rel/")
set(libjpeg_BIN_DIRS_DEBUG )
set(libjpeg_LIBRARY_TYPE_DEBUG STATIC)
set(libjpeg_IS_HOST_WINDOWS_DEBUG 0)
set(libjpeg_LIBS_DEBUG jpeg)
set(libjpeg_SYSTEM_LIBS_DEBUG )
set(libjpeg_FRAMEWORK_DIRS_DEBUG )
set(libjpeg_FRAMEWORKS_DEBUG )
set(libjpeg_BUILD_DIRS_DEBUG )
set(libjpeg_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(libjpeg_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${libjpeg_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${libjpeg_COMPILE_OPTIONS_C_DEBUG}>")
set(libjpeg_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${libjpeg_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${libjpeg_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${libjpeg_EXE_LINK_FLAGS_DEBUG}>")


set(libjpeg_COMPONENTS_DEBUG )