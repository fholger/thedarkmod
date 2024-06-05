########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(fltk_COMPONENT_NAMES "")
if(DEFINED fltk_FIND_DEPENDENCY_NAMES)
  list(APPEND fltk_FIND_DEPENDENCY_NAMES JPEG PNG ZLIB)
  list(REMOVE_DUPLICATES fltk_FIND_DEPENDENCY_NAMES)
else()
  set(fltk_FIND_DEPENDENCY_NAMES JPEG PNG ZLIB)
endif()
set(JPEG_FIND_MODE "NO_MODULE")
set(PNG_FIND_MODE "NO_MODULE")
set(ZLIB_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(fltk_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/fltk")
set(fltk_BUILD_MODULES_PATHS_RELEASE )


set(fltk_INCLUDE_DIRS_RELEASE "${fltk_PACKAGE_FOLDER_RELEASE}/include/")
set(fltk_RES_DIRS_RELEASE )
set(fltk_DEFINITIONS_RELEASE )
set(fltk_SHARED_LINK_FLAGS_RELEASE )
set(fltk_EXE_LINK_FLAGS_RELEASE )
set(fltk_OBJECTS_RELEASE )
set(fltk_COMPILE_DEFINITIONS_RELEASE )
set(fltk_COMPILE_OPTIONS_C_RELEASE )
set(fltk_COMPILE_OPTIONS_CXX_RELEASE )
set(fltk_LIB_DIRS_RELEASE "${fltk_PACKAGE_FOLDER_RELEASE}/lib/windows64_rel/")
set(fltk_BIN_DIRS_RELEASE )
set(fltk_LIBRARY_TYPE_RELEASE STATIC)
set(fltk_IS_HOST_WINDOWS_RELEASE 1)
set(fltk_LIBS_RELEASE fltk fltk_forms fltk_gl fltk_images)
set(fltk_SYSTEM_LIBS_RELEASE gdi32 imm32 msimg32 ole32 oleaut32 uuid comctl32 gdiplus opengl32)
set(fltk_FRAMEWORK_DIRS_RELEASE )
set(fltk_FRAMEWORKS_RELEASE )
set(fltk_BUILD_DIRS_RELEASE )
set(fltk_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(fltk_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${fltk_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${fltk_COMPILE_OPTIONS_C_RELEASE}>")
set(fltk_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${fltk_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${fltk_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${fltk_EXE_LINK_FLAGS_RELEASE}>")


set(fltk_COMPONENTS_RELEASE )