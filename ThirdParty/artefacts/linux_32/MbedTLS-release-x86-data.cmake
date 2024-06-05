########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND mbedtls_COMPONENT_NAMES MbedTLS::mbedcrypto MbedTLS::mbedx509 MbedTLS::mbedtls)
list(REMOVE_DUPLICATES mbedtls_COMPONENT_NAMES)
if(DEFINED mbedtls_FIND_DEPENDENCY_NAMES)
  list(APPEND mbedtls_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES mbedtls_FIND_DEPENDENCY_NAMES)
else()
  set(mbedtls_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(mbedtls_PACKAGE_FOLDER_RELEASE "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/mbedtls")
set(mbedtls_BUILD_MODULES_PATHS_RELEASE )


set(mbedtls_INCLUDE_DIRS_RELEASE "${mbedtls_PACKAGE_FOLDER_RELEASE}/include/")
set(mbedtls_RES_DIRS_RELEASE )
set(mbedtls_DEFINITIONS_RELEASE )
set(mbedtls_SHARED_LINK_FLAGS_RELEASE )
set(mbedtls_EXE_LINK_FLAGS_RELEASE )
set(mbedtls_OBJECTS_RELEASE )
set(mbedtls_COMPILE_DEFINITIONS_RELEASE )
set(mbedtls_COMPILE_OPTIONS_C_RELEASE )
set(mbedtls_COMPILE_OPTIONS_CXX_RELEASE )
set(mbedtls_LIB_DIRS_RELEASE "${mbedtls_PACKAGE_FOLDER_RELEASE}/lib/linux32_rel/")
set(mbedtls_BIN_DIRS_RELEASE )
set(mbedtls_LIBRARY_TYPE_RELEASE STATIC)
set(mbedtls_IS_HOST_WINDOWS_RELEASE 0)
set(mbedtls_LIBS_RELEASE mbedtls mbedx509 mbedcrypto)
set(mbedtls_SYSTEM_LIBS_RELEASE )
set(mbedtls_FRAMEWORK_DIRS_RELEASE )
set(mbedtls_FRAMEWORKS_RELEASE )
set(mbedtls_BUILD_DIRS_RELEASE )
set(mbedtls_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(mbedtls_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mbedtls_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mbedtls_COMPILE_OPTIONS_C_RELEASE}>")
set(mbedtls_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mbedtls_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mbedtls_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mbedtls_EXE_LINK_FLAGS_RELEASE}>")


set(mbedtls_COMPONENTS_RELEASE MbedTLS::mbedcrypto MbedTLS::mbedx509 MbedTLS::mbedtls)
########### COMPONENT MbedTLS::mbedtls VARIABLES ############################################

set(mbedtls_MbedTLS_mbedtls_INCLUDE_DIRS_RELEASE "${mbedtls_PACKAGE_FOLDER_RELEASE}/include/")
set(mbedtls_MbedTLS_mbedtls_LIB_DIRS_RELEASE "${mbedtls_PACKAGE_FOLDER_RELEASE}/lib/linux32_rel/")
set(mbedtls_MbedTLS_mbedtls_BIN_DIRS_RELEASE )
set(mbedtls_MbedTLS_mbedtls_LIBRARY_TYPE_RELEASE STATIC)
set(mbedtls_MbedTLS_mbedtls_IS_HOST_WINDOWS_RELEASE 0)
set(mbedtls_MbedTLS_mbedtls_RES_DIRS_RELEASE )
set(mbedtls_MbedTLS_mbedtls_DEFINITIONS_RELEASE )
set(mbedtls_MbedTLS_mbedtls_OBJECTS_RELEASE )
set(mbedtls_MbedTLS_mbedtls_COMPILE_DEFINITIONS_RELEASE )
set(mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_C_RELEASE "")
set(mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_CXX_RELEASE "")
set(mbedtls_MbedTLS_mbedtls_LIBS_RELEASE mbedtls)
set(mbedtls_MbedTLS_mbedtls_SYSTEM_LIBS_RELEASE )
set(mbedtls_MbedTLS_mbedtls_FRAMEWORK_DIRS_RELEASE )
set(mbedtls_MbedTLS_mbedtls_FRAMEWORKS_RELEASE )
set(mbedtls_MbedTLS_mbedtls_DEPENDENCIES_RELEASE MbedTLS::mbedx509)
set(mbedtls_MbedTLS_mbedtls_SHARED_LINK_FLAGS_RELEASE )
set(mbedtls_MbedTLS_mbedtls_EXE_LINK_FLAGS_RELEASE )
set(mbedtls_MbedTLS_mbedtls_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(mbedtls_MbedTLS_mbedtls_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mbedtls_MbedTLS_mbedtls_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mbedtls_MbedTLS_mbedtls_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mbedtls_MbedTLS_mbedtls_EXE_LINK_FLAGS_RELEASE}>
)
set(mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_C_RELEASE}>")
########### COMPONENT MbedTLS::mbedx509 VARIABLES ############################################

set(mbedtls_MbedTLS_mbedx509_INCLUDE_DIRS_RELEASE "${mbedtls_PACKAGE_FOLDER_RELEASE}/include/")
set(mbedtls_MbedTLS_mbedx509_LIB_DIRS_RELEASE "${mbedtls_PACKAGE_FOLDER_RELEASE}/lib/linux32_rel/")
set(mbedtls_MbedTLS_mbedx509_BIN_DIRS_RELEASE )
set(mbedtls_MbedTLS_mbedx509_LIBRARY_TYPE_RELEASE STATIC)
set(mbedtls_MbedTLS_mbedx509_IS_HOST_WINDOWS_RELEASE 0)
set(mbedtls_MbedTLS_mbedx509_RES_DIRS_RELEASE )
set(mbedtls_MbedTLS_mbedx509_DEFINITIONS_RELEASE )
set(mbedtls_MbedTLS_mbedx509_OBJECTS_RELEASE )
set(mbedtls_MbedTLS_mbedx509_COMPILE_DEFINITIONS_RELEASE )
set(mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_C_RELEASE "")
set(mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_CXX_RELEASE "")
set(mbedtls_MbedTLS_mbedx509_LIBS_RELEASE mbedx509)
set(mbedtls_MbedTLS_mbedx509_SYSTEM_LIBS_RELEASE )
set(mbedtls_MbedTLS_mbedx509_FRAMEWORK_DIRS_RELEASE )
set(mbedtls_MbedTLS_mbedx509_FRAMEWORKS_RELEASE )
set(mbedtls_MbedTLS_mbedx509_DEPENDENCIES_RELEASE MbedTLS::mbedcrypto)
set(mbedtls_MbedTLS_mbedx509_SHARED_LINK_FLAGS_RELEASE )
set(mbedtls_MbedTLS_mbedx509_EXE_LINK_FLAGS_RELEASE )
set(mbedtls_MbedTLS_mbedx509_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(mbedtls_MbedTLS_mbedx509_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mbedtls_MbedTLS_mbedx509_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mbedtls_MbedTLS_mbedx509_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mbedtls_MbedTLS_mbedx509_EXE_LINK_FLAGS_RELEASE}>
)
set(mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_C_RELEASE}>")
########### COMPONENT MbedTLS::mbedcrypto VARIABLES ############################################

set(mbedtls_MbedTLS_mbedcrypto_INCLUDE_DIRS_RELEASE "${mbedtls_PACKAGE_FOLDER_RELEASE}/include/")
set(mbedtls_MbedTLS_mbedcrypto_LIB_DIRS_RELEASE "${mbedtls_PACKAGE_FOLDER_RELEASE}/lib/linux32_rel/")
set(mbedtls_MbedTLS_mbedcrypto_BIN_DIRS_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_LIBRARY_TYPE_RELEASE STATIC)
set(mbedtls_MbedTLS_mbedcrypto_IS_HOST_WINDOWS_RELEASE 0)
set(mbedtls_MbedTLS_mbedcrypto_RES_DIRS_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_DEFINITIONS_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_OBJECTS_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_COMPILE_DEFINITIONS_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_C_RELEASE "")
set(mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_CXX_RELEASE "")
set(mbedtls_MbedTLS_mbedcrypto_LIBS_RELEASE mbedcrypto)
set(mbedtls_MbedTLS_mbedcrypto_SYSTEM_LIBS_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_FRAMEWORK_DIRS_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_FRAMEWORKS_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_DEPENDENCIES_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_SHARED_LINK_FLAGS_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_EXE_LINK_FLAGS_RELEASE )
set(mbedtls_MbedTLS_mbedcrypto_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(mbedtls_MbedTLS_mbedcrypto_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mbedtls_MbedTLS_mbedcrypto_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mbedtls_MbedTLS_mbedcrypto_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mbedtls_MbedTLS_mbedcrypto_EXE_LINK_FLAGS_RELEASE}>
)
set(mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_C_RELEASE}>")