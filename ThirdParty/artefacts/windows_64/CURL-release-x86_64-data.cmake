########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND libcurl_COMPONENT_NAMES CURL::libcurl)
list(REMOVE_DUPLICATES libcurl_COMPONENT_NAMES)
if(DEFINED libcurl_FIND_DEPENDENCY_NAMES)
  list(APPEND libcurl_FIND_DEPENDENCY_NAMES MbedTLS ZLIB)
  list(REMOVE_DUPLICATES libcurl_FIND_DEPENDENCY_NAMES)
else()
  set(libcurl_FIND_DEPENDENCY_NAMES MbedTLS ZLIB)
endif()
set(MbedTLS_FIND_MODE "NO_MODULE")
set(ZLIB_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(libcurl_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/libcurl")
set(libcurl_BUILD_MODULES_PATHS_RELEASE )


set(libcurl_INCLUDE_DIRS_RELEASE "${libcurl_PACKAGE_FOLDER_RELEASE}/include/")
set(libcurl_RES_DIRS_RELEASE "${libcurl_PACKAGE_FOLDER_RELEASE}/res")
set(libcurl_DEFINITIONS_RELEASE "-DCURL_STATICLIB=1")
set(libcurl_SHARED_LINK_FLAGS_RELEASE )
set(libcurl_EXE_LINK_FLAGS_RELEASE )
set(libcurl_OBJECTS_RELEASE )
set(libcurl_COMPILE_DEFINITIONS_RELEASE "CURL_STATICLIB=1")
set(libcurl_COMPILE_OPTIONS_C_RELEASE )
set(libcurl_COMPILE_OPTIONS_CXX_RELEASE )
set(libcurl_LIB_DIRS_RELEASE "${libcurl_PACKAGE_FOLDER_RELEASE}/lib/windows64_rel/")
set(libcurl_BIN_DIRS_RELEASE )
set(libcurl_LIBRARY_TYPE_RELEASE STATIC)
set(libcurl_IS_HOST_WINDOWS_RELEASE 1)
set(libcurl_LIBS_RELEASE libcurl)
set(libcurl_SYSTEM_LIBS_RELEASE ws2_32)
set(libcurl_FRAMEWORK_DIRS_RELEASE )
set(libcurl_FRAMEWORKS_RELEASE )
set(libcurl_BUILD_DIRS_RELEASE )
set(libcurl_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(libcurl_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${libcurl_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${libcurl_COMPILE_OPTIONS_C_RELEASE}>")
set(libcurl_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${libcurl_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${libcurl_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${libcurl_EXE_LINK_FLAGS_RELEASE}>")


set(libcurl_COMPONENTS_RELEASE CURL::libcurl)
########### COMPONENT CURL::libcurl VARIABLES ############################################

set(libcurl_CURL_libcurl_INCLUDE_DIRS_RELEASE "${libcurl_PACKAGE_FOLDER_RELEASE}/include/")
set(libcurl_CURL_libcurl_LIB_DIRS_RELEASE "${libcurl_PACKAGE_FOLDER_RELEASE}/lib/windows64_rel/")
set(libcurl_CURL_libcurl_BIN_DIRS_RELEASE )
set(libcurl_CURL_libcurl_LIBRARY_TYPE_RELEASE STATIC)
set(libcurl_CURL_libcurl_IS_HOST_WINDOWS_RELEASE 1)
set(libcurl_CURL_libcurl_RES_DIRS_RELEASE "${libcurl_PACKAGE_FOLDER_RELEASE}/res")
set(libcurl_CURL_libcurl_DEFINITIONS_RELEASE "-DCURL_STATICLIB=1")
set(libcurl_CURL_libcurl_OBJECTS_RELEASE )
set(libcurl_CURL_libcurl_COMPILE_DEFINITIONS_RELEASE "CURL_STATICLIB=1")
set(libcurl_CURL_libcurl_COMPILE_OPTIONS_C_RELEASE "")
set(libcurl_CURL_libcurl_COMPILE_OPTIONS_CXX_RELEASE "")
set(libcurl_CURL_libcurl_LIBS_RELEASE libcurl)
set(libcurl_CURL_libcurl_SYSTEM_LIBS_RELEASE ws2_32)
set(libcurl_CURL_libcurl_FRAMEWORK_DIRS_RELEASE )
set(libcurl_CURL_libcurl_FRAMEWORKS_RELEASE )
set(libcurl_CURL_libcurl_DEPENDENCIES_RELEASE MbedTLS::mbedtls ZLIB::ZLIB)
set(libcurl_CURL_libcurl_SHARED_LINK_FLAGS_RELEASE )
set(libcurl_CURL_libcurl_EXE_LINK_FLAGS_RELEASE )
set(libcurl_CURL_libcurl_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(libcurl_CURL_libcurl_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${libcurl_CURL_libcurl_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${libcurl_CURL_libcurl_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${libcurl_CURL_libcurl_EXE_LINK_FLAGS_RELEASE}>
)
set(libcurl_CURL_libcurl_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${libcurl_CURL_libcurl_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${libcurl_CURL_libcurl_COMPILE_OPTIONS_C_RELEASE}>")