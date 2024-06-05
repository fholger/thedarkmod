########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(glu_COMPONENT_NAMES "")
if(DEFINED glu_FIND_DEPENDENCY_NAMES)
  list(APPEND glu_FIND_DEPENDENCY_NAMES opengl_system)
  list(REMOVE_DUPLICATES glu_FIND_DEPENDENCY_NAMES)
else()
  set(glu_FIND_DEPENDENCY_NAMES opengl_system)
endif()
set(opengl_system_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(glu_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/glu")
set(glu_BUILD_MODULES_PATHS_RELEASE )


set(glu_INCLUDE_DIRS_RELEASE )
set(glu_RES_DIRS_RELEASE )
set(glu_DEFINITIONS_RELEASE )
set(glu_SHARED_LINK_FLAGS_RELEASE )
set(glu_EXE_LINK_FLAGS_RELEASE )
set(glu_OBJECTS_RELEASE )
set(glu_COMPILE_DEFINITIONS_RELEASE )
set(glu_COMPILE_OPTIONS_C_RELEASE )
set(glu_COMPILE_OPTIONS_CXX_RELEASE )
set(glu_LIB_DIRS_RELEASE )
set(glu_BIN_DIRS_RELEASE )
set(glu_LIBRARY_TYPE_RELEASE SHARED)
set(glu_IS_HOST_WINDOWS_RELEASE 0)
set(glu_LIBS_RELEASE )
set(glu_SYSTEM_LIBS_RELEASE GLU GL)
set(glu_FRAMEWORK_DIRS_RELEASE )
set(glu_FRAMEWORKS_RELEASE )
set(glu_BUILD_DIRS_RELEASE )
set(glu_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(glu_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${glu_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${glu_COMPILE_OPTIONS_C_RELEASE}>")
set(glu_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${glu_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${glu_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${glu_EXE_LINK_FLAGS_RELEASE}>")


set(glu_COMPONENTS_RELEASE )