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
set(fltk_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/fltk")
set(fltk_BUILD_MODULES_PATHS_DEBUG )


set(fltk_INCLUDE_DIRS_DEBUG "${fltk_PACKAGE_FOLDER_DEBUG}/include/")
set(fltk_RES_DIRS_DEBUG )
set(fltk_DEFINITIONS_DEBUG )
set(fltk_SHARED_LINK_FLAGS_DEBUG )
set(fltk_EXE_LINK_FLAGS_DEBUG )
set(fltk_OBJECTS_DEBUG )
set(fltk_COMPILE_DEFINITIONS_DEBUG )
set(fltk_COMPILE_OPTIONS_C_DEBUG )
set(fltk_COMPILE_OPTIONS_CXX_DEBUG )
set(fltk_LIB_DIRS_DEBUG "${fltk_PACKAGE_FOLDER_DEBUG}/lib/windows64_rel/")
set(fltk_BIN_DIRS_DEBUG )
set(fltk_LIBRARY_TYPE_DEBUG STATIC)
set(fltk_IS_HOST_WINDOWS_DEBUG 1)
set(fltk_LIBS_DEBUG fltk fltk_forms fltk_gl fltk_images)
set(fltk_SYSTEM_LIBS_DEBUG gdi32 imm32 msimg32 ole32 oleaut32 uuid comctl32 gdiplus opengl32)
set(fltk_FRAMEWORK_DIRS_DEBUG )
set(fltk_FRAMEWORKS_DEBUG )
set(fltk_BUILD_DIRS_DEBUG )
set(fltk_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(fltk_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${fltk_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${fltk_COMPILE_OPTIONS_C_DEBUG}>")
set(fltk_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${fltk_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${fltk_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${fltk_EXE_LINK_FLAGS_DEBUG}>")


set(fltk_COMPONENTS_DEBUG )