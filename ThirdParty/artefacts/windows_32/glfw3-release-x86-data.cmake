########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(glfw_COMPONENT_NAMES "")
if(DEFINED glfw_FIND_DEPENDENCY_NAMES)
  list(APPEND glfw_FIND_DEPENDENCY_NAMES opengl_system)
  list(REMOVE_DUPLICATES glfw_FIND_DEPENDENCY_NAMES)
else()
  set(glfw_FIND_DEPENDENCY_NAMES opengl_system)
endif()
set(opengl_system_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(glfw_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/glfw")
set(glfw_BUILD_MODULES_PATHS_RELEASE )


set(glfw_INCLUDE_DIRS_RELEASE "${glfw_PACKAGE_FOLDER_RELEASE}/include/")
set(glfw_RES_DIRS_RELEASE )
set(glfw_DEFINITIONS_RELEASE )
set(glfw_SHARED_LINK_FLAGS_RELEASE )
set(glfw_EXE_LINK_FLAGS_RELEASE )
set(glfw_OBJECTS_RELEASE )
set(glfw_COMPILE_DEFINITIONS_RELEASE )
set(glfw_COMPILE_OPTIONS_C_RELEASE )
set(glfw_COMPILE_OPTIONS_CXX_RELEASE )
set(glfw_LIB_DIRS_RELEASE "${glfw_PACKAGE_FOLDER_RELEASE}/lib/windows32_rel/")
set(glfw_BIN_DIRS_RELEASE )
set(glfw_LIBRARY_TYPE_RELEASE STATIC)
set(glfw_IS_HOST_WINDOWS_RELEASE 1)
set(glfw_LIBS_RELEASE glfw3)
set(glfw_SYSTEM_LIBS_RELEASE gdi32)
set(glfw_FRAMEWORK_DIRS_RELEASE )
set(glfw_FRAMEWORKS_RELEASE )
set(glfw_BUILD_DIRS_RELEASE )
set(glfw_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(glfw_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${glfw_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${glfw_COMPILE_OPTIONS_C_RELEASE}>")
set(glfw_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${glfw_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${glfw_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${glfw_EXE_LINK_FLAGS_RELEASE}>")


set(glfw_COMPONENTS_RELEASE )