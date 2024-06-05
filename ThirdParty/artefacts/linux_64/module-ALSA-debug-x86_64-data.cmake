########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(libalsa_COMPONENT_NAMES "")
if(DEFINED libalsa_FIND_DEPENDENCY_NAMES)
  list(APPEND libalsa_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES libalsa_FIND_DEPENDENCY_NAMES)
else()
  set(libalsa_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(libalsa_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/libalsa")
set(libalsa_BUILD_MODULES_PATHS_DEBUG )


set(libalsa_INCLUDE_DIRS_DEBUG "${libalsa_PACKAGE_FOLDER_DEBUG}/include/")
set(libalsa_RES_DIRS_DEBUG "${libalsa_PACKAGE_FOLDER_DEBUG}/res")
set(libalsa_DEFINITIONS_DEBUG )
set(libalsa_SHARED_LINK_FLAGS_DEBUG )
set(libalsa_EXE_LINK_FLAGS_DEBUG )
set(libalsa_OBJECTS_DEBUG )
set(libalsa_COMPILE_DEFINITIONS_DEBUG )
set(libalsa_COMPILE_OPTIONS_C_DEBUG )
set(libalsa_COMPILE_OPTIONS_CXX_DEBUG )
set(libalsa_LIB_DIRS_DEBUG "${libalsa_PACKAGE_FOLDER_DEBUG}/lib/linux64_rel/")
set(libalsa_BIN_DIRS_DEBUG )
set(libalsa_LIBRARY_TYPE_DEBUG STATIC)
set(libalsa_IS_HOST_WINDOWS_DEBUG 0)
set(libalsa_LIBS_DEBUG asound)
set(libalsa_SYSTEM_LIBS_DEBUG dl m rt pthread)
set(libalsa_FRAMEWORK_DIRS_DEBUG )
set(libalsa_FRAMEWORKS_DEBUG )
set(libalsa_BUILD_DIRS_DEBUG )
set(libalsa_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(libalsa_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${libalsa_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${libalsa_COMPILE_OPTIONS_C_DEBUG}>")
set(libalsa_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${libalsa_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${libalsa_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${libalsa_EXE_LINK_FLAGS_DEBUG}>")


set(libalsa_COMPONENTS_DEBUG )