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
set(glu_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/glu")
set(glu_BUILD_MODULES_PATHS_DEBUG )


set(glu_INCLUDE_DIRS_DEBUG )
set(glu_RES_DIRS_DEBUG )
set(glu_DEFINITIONS_DEBUG )
set(glu_SHARED_LINK_FLAGS_DEBUG )
set(glu_EXE_LINK_FLAGS_DEBUG )
set(glu_OBJECTS_DEBUG )
set(glu_COMPILE_DEFINITIONS_DEBUG )
set(glu_COMPILE_OPTIONS_C_DEBUG )
set(glu_COMPILE_OPTIONS_CXX_DEBUG )
set(glu_LIB_DIRS_DEBUG )
set(glu_BIN_DIRS_DEBUG )
set(glu_LIBRARY_TYPE_DEBUG SHARED)
set(glu_IS_HOST_WINDOWS_DEBUG 0)
set(glu_LIBS_DEBUG )
set(glu_SYSTEM_LIBS_DEBUG GLU GL)
set(glu_FRAMEWORK_DIRS_DEBUG )
set(glu_FRAMEWORKS_DEBUG )
set(glu_BUILD_DIRS_DEBUG )
set(glu_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(glu_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${glu_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${glu_COMPILE_OPTIONS_C_DEBUG}>")
set(glu_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${glu_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${glu_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${glu_EXE_LINK_FLAGS_DEBUG}>")


set(glu_COMPONENTS_DEBUG )