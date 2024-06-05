########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND ffmpeg_COMPONENT_NAMES ffmpeg::avutil ffmpeg::swscale ffmpeg::swresample ffmpeg::avcodec ffmpeg::avformat)
list(REMOVE_DUPLICATES ffmpeg_COMPONENT_NAMES)
if(DEFINED ffmpeg_FIND_DEPENDENCY_NAMES)
  list(APPEND ffmpeg_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES ffmpeg_FIND_DEPENDENCY_NAMES)
else()
  set(ffmpeg_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(ffmpeg_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/ffmpeg")
set(ffmpeg_BUILD_MODULES_PATHS_DEBUG )


set(ffmpeg_INCLUDE_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/include/")
set(ffmpeg_RES_DIRS_DEBUG )
set(ffmpeg_DEFINITIONS_DEBUG )
set(ffmpeg_SHARED_LINK_FLAGS_DEBUG )
set(ffmpeg_EXE_LINK_FLAGS_DEBUG )
set(ffmpeg_OBJECTS_DEBUG )
set(ffmpeg_COMPILE_DEFINITIONS_DEBUG )
set(ffmpeg_COMPILE_OPTIONS_C_DEBUG )
set(ffmpeg_COMPILE_OPTIONS_CXX_DEBUG )
set(ffmpeg_LIB_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/lib/linux64_rel/")
set(ffmpeg_BIN_DIRS_DEBUG )
set(ffmpeg_LIBRARY_TYPE_DEBUG STATIC)
set(ffmpeg_IS_HOST_WINDOWS_DEBUG 0)
set(ffmpeg_LIBS_DEBUG avformat avcodec swresample swscale avutil)
set(ffmpeg_SYSTEM_LIBS_DEBUG m pthread dl)
set(ffmpeg_FRAMEWORK_DIRS_DEBUG )
set(ffmpeg_FRAMEWORKS_DEBUG )
set(ffmpeg_BUILD_DIRS_DEBUG )
set(ffmpeg_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(ffmpeg_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${ffmpeg_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${ffmpeg_COMPILE_OPTIONS_C_DEBUG}>")
set(ffmpeg_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${ffmpeg_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${ffmpeg_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${ffmpeg_EXE_LINK_FLAGS_DEBUG}>")


set(ffmpeg_COMPONENTS_DEBUG ffmpeg::avutil ffmpeg::swscale ffmpeg::swresample ffmpeg::avcodec ffmpeg::avformat)
########### COMPONENT ffmpeg::avformat VARIABLES ############################################

set(ffmpeg_ffmpeg_avformat_INCLUDE_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/include/")
set(ffmpeg_ffmpeg_avformat_LIB_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/lib/linux64_rel/")
set(ffmpeg_ffmpeg_avformat_BIN_DIRS_DEBUG )
set(ffmpeg_ffmpeg_avformat_LIBRARY_TYPE_DEBUG STATIC)
set(ffmpeg_ffmpeg_avformat_IS_HOST_WINDOWS_DEBUG 0)
set(ffmpeg_ffmpeg_avformat_RES_DIRS_DEBUG )
set(ffmpeg_ffmpeg_avformat_DEFINITIONS_DEBUG )
set(ffmpeg_ffmpeg_avformat_OBJECTS_DEBUG )
set(ffmpeg_ffmpeg_avformat_COMPILE_DEFINITIONS_DEBUG )
set(ffmpeg_ffmpeg_avformat_COMPILE_OPTIONS_C_DEBUG "")
set(ffmpeg_ffmpeg_avformat_COMPILE_OPTIONS_CXX_DEBUG "")
set(ffmpeg_ffmpeg_avformat_LIBS_DEBUG avformat)
set(ffmpeg_ffmpeg_avformat_SYSTEM_LIBS_DEBUG m)
set(ffmpeg_ffmpeg_avformat_FRAMEWORK_DIRS_DEBUG )
set(ffmpeg_ffmpeg_avformat_FRAMEWORKS_DEBUG )
set(ffmpeg_ffmpeg_avformat_DEPENDENCIES_DEBUG ffmpeg::avutil ffmpeg::avcodec ffmpeg::swresample)
set(ffmpeg_ffmpeg_avformat_SHARED_LINK_FLAGS_DEBUG )
set(ffmpeg_ffmpeg_avformat_EXE_LINK_FLAGS_DEBUG )
set(ffmpeg_ffmpeg_avformat_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(ffmpeg_ffmpeg_avformat_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${ffmpeg_ffmpeg_avformat_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${ffmpeg_ffmpeg_avformat_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${ffmpeg_ffmpeg_avformat_EXE_LINK_FLAGS_DEBUG}>
)
set(ffmpeg_ffmpeg_avformat_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${ffmpeg_ffmpeg_avformat_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${ffmpeg_ffmpeg_avformat_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT ffmpeg::avcodec VARIABLES ############################################

set(ffmpeg_ffmpeg_avcodec_INCLUDE_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/include/")
set(ffmpeg_ffmpeg_avcodec_LIB_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/lib/linux64_rel/")
set(ffmpeg_ffmpeg_avcodec_BIN_DIRS_DEBUG )
set(ffmpeg_ffmpeg_avcodec_LIBRARY_TYPE_DEBUG STATIC)
set(ffmpeg_ffmpeg_avcodec_IS_HOST_WINDOWS_DEBUG 0)
set(ffmpeg_ffmpeg_avcodec_RES_DIRS_DEBUG )
set(ffmpeg_ffmpeg_avcodec_DEFINITIONS_DEBUG )
set(ffmpeg_ffmpeg_avcodec_OBJECTS_DEBUG )
set(ffmpeg_ffmpeg_avcodec_COMPILE_DEFINITIONS_DEBUG )
set(ffmpeg_ffmpeg_avcodec_COMPILE_OPTIONS_C_DEBUG "")
set(ffmpeg_ffmpeg_avcodec_COMPILE_OPTIONS_CXX_DEBUG "")
set(ffmpeg_ffmpeg_avcodec_LIBS_DEBUG avcodec)
set(ffmpeg_ffmpeg_avcodec_SYSTEM_LIBS_DEBUG )
set(ffmpeg_ffmpeg_avcodec_FRAMEWORK_DIRS_DEBUG )
set(ffmpeg_ffmpeg_avcodec_FRAMEWORKS_DEBUG )
set(ffmpeg_ffmpeg_avcodec_DEPENDENCIES_DEBUG ffmpeg::avutil ffmpeg::swresample)
set(ffmpeg_ffmpeg_avcodec_SHARED_LINK_FLAGS_DEBUG )
set(ffmpeg_ffmpeg_avcodec_EXE_LINK_FLAGS_DEBUG )
set(ffmpeg_ffmpeg_avcodec_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(ffmpeg_ffmpeg_avcodec_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${ffmpeg_ffmpeg_avcodec_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${ffmpeg_ffmpeg_avcodec_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${ffmpeg_ffmpeg_avcodec_EXE_LINK_FLAGS_DEBUG}>
)
set(ffmpeg_ffmpeg_avcodec_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${ffmpeg_ffmpeg_avcodec_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${ffmpeg_ffmpeg_avcodec_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT ffmpeg::swresample VARIABLES ############################################

set(ffmpeg_ffmpeg_swresample_INCLUDE_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/include/")
set(ffmpeg_ffmpeg_swresample_LIB_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/lib/linux64_rel/")
set(ffmpeg_ffmpeg_swresample_BIN_DIRS_DEBUG )
set(ffmpeg_ffmpeg_swresample_LIBRARY_TYPE_DEBUG STATIC)
set(ffmpeg_ffmpeg_swresample_IS_HOST_WINDOWS_DEBUG 0)
set(ffmpeg_ffmpeg_swresample_RES_DIRS_DEBUG )
set(ffmpeg_ffmpeg_swresample_DEFINITIONS_DEBUG )
set(ffmpeg_ffmpeg_swresample_OBJECTS_DEBUG )
set(ffmpeg_ffmpeg_swresample_COMPILE_DEFINITIONS_DEBUG )
set(ffmpeg_ffmpeg_swresample_COMPILE_OPTIONS_C_DEBUG "")
set(ffmpeg_ffmpeg_swresample_COMPILE_OPTIONS_CXX_DEBUG "")
set(ffmpeg_ffmpeg_swresample_LIBS_DEBUG swresample)
set(ffmpeg_ffmpeg_swresample_SYSTEM_LIBS_DEBUG m)
set(ffmpeg_ffmpeg_swresample_FRAMEWORK_DIRS_DEBUG )
set(ffmpeg_ffmpeg_swresample_FRAMEWORKS_DEBUG )
set(ffmpeg_ffmpeg_swresample_DEPENDENCIES_DEBUG ffmpeg::avutil)
set(ffmpeg_ffmpeg_swresample_SHARED_LINK_FLAGS_DEBUG )
set(ffmpeg_ffmpeg_swresample_EXE_LINK_FLAGS_DEBUG )
set(ffmpeg_ffmpeg_swresample_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(ffmpeg_ffmpeg_swresample_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${ffmpeg_ffmpeg_swresample_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${ffmpeg_ffmpeg_swresample_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${ffmpeg_ffmpeg_swresample_EXE_LINK_FLAGS_DEBUG}>
)
set(ffmpeg_ffmpeg_swresample_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${ffmpeg_ffmpeg_swresample_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${ffmpeg_ffmpeg_swresample_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT ffmpeg::swscale VARIABLES ############################################

set(ffmpeg_ffmpeg_swscale_INCLUDE_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/include/")
set(ffmpeg_ffmpeg_swscale_LIB_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/lib/linux64_rel/")
set(ffmpeg_ffmpeg_swscale_BIN_DIRS_DEBUG )
set(ffmpeg_ffmpeg_swscale_LIBRARY_TYPE_DEBUG STATIC)
set(ffmpeg_ffmpeg_swscale_IS_HOST_WINDOWS_DEBUG 0)
set(ffmpeg_ffmpeg_swscale_RES_DIRS_DEBUG )
set(ffmpeg_ffmpeg_swscale_DEFINITIONS_DEBUG )
set(ffmpeg_ffmpeg_swscale_OBJECTS_DEBUG )
set(ffmpeg_ffmpeg_swscale_COMPILE_DEFINITIONS_DEBUG )
set(ffmpeg_ffmpeg_swscale_COMPILE_OPTIONS_C_DEBUG "")
set(ffmpeg_ffmpeg_swscale_COMPILE_OPTIONS_CXX_DEBUG "")
set(ffmpeg_ffmpeg_swscale_LIBS_DEBUG swscale)
set(ffmpeg_ffmpeg_swscale_SYSTEM_LIBS_DEBUG m)
set(ffmpeg_ffmpeg_swscale_FRAMEWORK_DIRS_DEBUG )
set(ffmpeg_ffmpeg_swscale_FRAMEWORKS_DEBUG )
set(ffmpeg_ffmpeg_swscale_DEPENDENCIES_DEBUG ffmpeg::avutil)
set(ffmpeg_ffmpeg_swscale_SHARED_LINK_FLAGS_DEBUG )
set(ffmpeg_ffmpeg_swscale_EXE_LINK_FLAGS_DEBUG )
set(ffmpeg_ffmpeg_swscale_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(ffmpeg_ffmpeg_swscale_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${ffmpeg_ffmpeg_swscale_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${ffmpeg_ffmpeg_swscale_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${ffmpeg_ffmpeg_swscale_EXE_LINK_FLAGS_DEBUG}>
)
set(ffmpeg_ffmpeg_swscale_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${ffmpeg_ffmpeg_swscale_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${ffmpeg_ffmpeg_swscale_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT ffmpeg::avutil VARIABLES ############################################

set(ffmpeg_ffmpeg_avutil_INCLUDE_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/include/")
set(ffmpeg_ffmpeg_avutil_LIB_DIRS_DEBUG "${ffmpeg_PACKAGE_FOLDER_DEBUG}/lib/linux64_rel/")
set(ffmpeg_ffmpeg_avutil_BIN_DIRS_DEBUG )
set(ffmpeg_ffmpeg_avutil_LIBRARY_TYPE_DEBUG STATIC)
set(ffmpeg_ffmpeg_avutil_IS_HOST_WINDOWS_DEBUG 0)
set(ffmpeg_ffmpeg_avutil_RES_DIRS_DEBUG )
set(ffmpeg_ffmpeg_avutil_DEFINITIONS_DEBUG )
set(ffmpeg_ffmpeg_avutil_OBJECTS_DEBUG )
set(ffmpeg_ffmpeg_avutil_COMPILE_DEFINITIONS_DEBUG )
set(ffmpeg_ffmpeg_avutil_COMPILE_OPTIONS_C_DEBUG "")
set(ffmpeg_ffmpeg_avutil_COMPILE_OPTIONS_CXX_DEBUG "")
set(ffmpeg_ffmpeg_avutil_LIBS_DEBUG avutil)
set(ffmpeg_ffmpeg_avutil_SYSTEM_LIBS_DEBUG pthread m dl)
set(ffmpeg_ffmpeg_avutil_FRAMEWORK_DIRS_DEBUG )
set(ffmpeg_ffmpeg_avutil_FRAMEWORKS_DEBUG )
set(ffmpeg_ffmpeg_avutil_DEPENDENCIES_DEBUG )
set(ffmpeg_ffmpeg_avutil_SHARED_LINK_FLAGS_DEBUG )
set(ffmpeg_ffmpeg_avutil_EXE_LINK_FLAGS_DEBUG )
set(ffmpeg_ffmpeg_avutil_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(ffmpeg_ffmpeg_avutil_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${ffmpeg_ffmpeg_avutil_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${ffmpeg_ffmpeg_avutil_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${ffmpeg_ffmpeg_avutil_EXE_LINK_FLAGS_DEBUG}>
)
set(ffmpeg_ffmpeg_avutil_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${ffmpeg_ffmpeg_avutil_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${ffmpeg_ffmpeg_avutil_COMPILE_OPTIONS_C_DEBUG}>")