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
set(mbedtls_PACKAGE_FOLDER_DEBUG "${CMAKE_CURRENT_LIST_DIR}/../tdm_deploy/mbedtls")
set(mbedtls_BUILD_MODULES_PATHS_DEBUG )


set(mbedtls_INCLUDE_DIRS_DEBUG "${mbedtls_PACKAGE_FOLDER_DEBUG}/include/")
set(mbedtls_RES_DIRS_DEBUG )
set(mbedtls_DEFINITIONS_DEBUG )
set(mbedtls_SHARED_LINK_FLAGS_DEBUG )
set(mbedtls_EXE_LINK_FLAGS_DEBUG )
set(mbedtls_OBJECTS_DEBUG )
set(mbedtls_COMPILE_DEFINITIONS_DEBUG )
set(mbedtls_COMPILE_OPTIONS_C_DEBUG )
set(mbedtls_COMPILE_OPTIONS_CXX_DEBUG )
set(mbedtls_LIB_DIRS_DEBUG "${mbedtls_PACKAGE_FOLDER_DEBUG}/lib/windows32_rel/")
set(mbedtls_BIN_DIRS_DEBUG )
set(mbedtls_LIBRARY_TYPE_DEBUG STATIC)
set(mbedtls_IS_HOST_WINDOWS_DEBUG 1)
set(mbedtls_LIBS_DEBUG mbedtls mbedx509 mbedcrypto)
set(mbedtls_SYSTEM_LIBS_DEBUG ws2_32 bcrypt)
set(mbedtls_FRAMEWORK_DIRS_DEBUG )
set(mbedtls_FRAMEWORKS_DEBUG )
set(mbedtls_BUILD_DIRS_DEBUG )
set(mbedtls_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(mbedtls_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${mbedtls_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${mbedtls_COMPILE_OPTIONS_C_DEBUG}>")
set(mbedtls_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mbedtls_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mbedtls_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mbedtls_EXE_LINK_FLAGS_DEBUG}>")


set(mbedtls_COMPONENTS_DEBUG MbedTLS::mbedcrypto MbedTLS::mbedx509 MbedTLS::mbedtls)
########### COMPONENT MbedTLS::mbedtls VARIABLES ############################################

set(mbedtls_MbedTLS_mbedtls_INCLUDE_DIRS_DEBUG "${mbedtls_PACKAGE_FOLDER_DEBUG}/include/")
set(mbedtls_MbedTLS_mbedtls_LIB_DIRS_DEBUG "${mbedtls_PACKAGE_FOLDER_DEBUG}/lib/windows32_rel/")
set(mbedtls_MbedTLS_mbedtls_BIN_DIRS_DEBUG )
set(mbedtls_MbedTLS_mbedtls_LIBRARY_TYPE_DEBUG STATIC)
set(mbedtls_MbedTLS_mbedtls_IS_HOST_WINDOWS_DEBUG 1)
set(mbedtls_MbedTLS_mbedtls_RES_DIRS_DEBUG )
set(mbedtls_MbedTLS_mbedtls_DEFINITIONS_DEBUG )
set(mbedtls_MbedTLS_mbedtls_OBJECTS_DEBUG )
set(mbedtls_MbedTLS_mbedtls_COMPILE_DEFINITIONS_DEBUG )
set(mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_C_DEBUG "")
set(mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_CXX_DEBUG "")
set(mbedtls_MbedTLS_mbedtls_LIBS_DEBUG mbedtls)
set(mbedtls_MbedTLS_mbedtls_SYSTEM_LIBS_DEBUG )
set(mbedtls_MbedTLS_mbedtls_FRAMEWORK_DIRS_DEBUG )
set(mbedtls_MbedTLS_mbedtls_FRAMEWORKS_DEBUG )
set(mbedtls_MbedTLS_mbedtls_DEPENDENCIES_DEBUG MbedTLS::mbedx509)
set(mbedtls_MbedTLS_mbedtls_SHARED_LINK_FLAGS_DEBUG )
set(mbedtls_MbedTLS_mbedtls_EXE_LINK_FLAGS_DEBUG )
set(mbedtls_MbedTLS_mbedtls_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(mbedtls_MbedTLS_mbedtls_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mbedtls_MbedTLS_mbedtls_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mbedtls_MbedTLS_mbedtls_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mbedtls_MbedTLS_mbedtls_EXE_LINK_FLAGS_DEBUG}>
)
set(mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${mbedtls_MbedTLS_mbedtls_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT MbedTLS::mbedx509 VARIABLES ############################################

set(mbedtls_MbedTLS_mbedx509_INCLUDE_DIRS_DEBUG "${mbedtls_PACKAGE_FOLDER_DEBUG}/include/")
set(mbedtls_MbedTLS_mbedx509_LIB_DIRS_DEBUG "${mbedtls_PACKAGE_FOLDER_DEBUG}/lib/windows32_rel/")
set(mbedtls_MbedTLS_mbedx509_BIN_DIRS_DEBUG )
set(mbedtls_MbedTLS_mbedx509_LIBRARY_TYPE_DEBUG STATIC)
set(mbedtls_MbedTLS_mbedx509_IS_HOST_WINDOWS_DEBUG 1)
set(mbedtls_MbedTLS_mbedx509_RES_DIRS_DEBUG )
set(mbedtls_MbedTLS_mbedx509_DEFINITIONS_DEBUG )
set(mbedtls_MbedTLS_mbedx509_OBJECTS_DEBUG )
set(mbedtls_MbedTLS_mbedx509_COMPILE_DEFINITIONS_DEBUG )
set(mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_C_DEBUG "")
set(mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_CXX_DEBUG "")
set(mbedtls_MbedTLS_mbedx509_LIBS_DEBUG mbedx509)
set(mbedtls_MbedTLS_mbedx509_SYSTEM_LIBS_DEBUG ws2_32)
set(mbedtls_MbedTLS_mbedx509_FRAMEWORK_DIRS_DEBUG )
set(mbedtls_MbedTLS_mbedx509_FRAMEWORKS_DEBUG )
set(mbedtls_MbedTLS_mbedx509_DEPENDENCIES_DEBUG MbedTLS::mbedcrypto)
set(mbedtls_MbedTLS_mbedx509_SHARED_LINK_FLAGS_DEBUG )
set(mbedtls_MbedTLS_mbedx509_EXE_LINK_FLAGS_DEBUG )
set(mbedtls_MbedTLS_mbedx509_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(mbedtls_MbedTLS_mbedx509_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mbedtls_MbedTLS_mbedx509_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mbedtls_MbedTLS_mbedx509_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mbedtls_MbedTLS_mbedx509_EXE_LINK_FLAGS_DEBUG}>
)
set(mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${mbedtls_MbedTLS_mbedx509_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT MbedTLS::mbedcrypto VARIABLES ############################################

set(mbedtls_MbedTLS_mbedcrypto_INCLUDE_DIRS_DEBUG "${mbedtls_PACKAGE_FOLDER_DEBUG}/include/")
set(mbedtls_MbedTLS_mbedcrypto_LIB_DIRS_DEBUG "${mbedtls_PACKAGE_FOLDER_DEBUG}/lib/windows32_rel/")
set(mbedtls_MbedTLS_mbedcrypto_BIN_DIRS_DEBUG )
set(mbedtls_MbedTLS_mbedcrypto_LIBRARY_TYPE_DEBUG STATIC)
set(mbedtls_MbedTLS_mbedcrypto_IS_HOST_WINDOWS_DEBUG 1)
set(mbedtls_MbedTLS_mbedcrypto_RES_DIRS_DEBUG )
set(mbedtls_MbedTLS_mbedcrypto_DEFINITIONS_DEBUG )
set(mbedtls_MbedTLS_mbedcrypto_OBJECTS_DEBUG )
set(mbedtls_MbedTLS_mbedcrypto_COMPILE_DEFINITIONS_DEBUG )
set(mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_C_DEBUG "")
set(mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_CXX_DEBUG "")
set(mbedtls_MbedTLS_mbedcrypto_LIBS_DEBUG mbedcrypto)
set(mbedtls_MbedTLS_mbedcrypto_SYSTEM_LIBS_DEBUG bcrypt)
set(mbedtls_MbedTLS_mbedcrypto_FRAMEWORK_DIRS_DEBUG )
set(mbedtls_MbedTLS_mbedcrypto_FRAMEWORKS_DEBUG )
set(mbedtls_MbedTLS_mbedcrypto_DEPENDENCIES_DEBUG )
set(mbedtls_MbedTLS_mbedcrypto_SHARED_LINK_FLAGS_DEBUG )
set(mbedtls_MbedTLS_mbedcrypto_EXE_LINK_FLAGS_DEBUG )
set(mbedtls_MbedTLS_mbedcrypto_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(mbedtls_MbedTLS_mbedcrypto_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mbedtls_MbedTLS_mbedcrypto_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mbedtls_MbedTLS_mbedcrypto_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mbedtls_MbedTLS_mbedcrypto_EXE_LINK_FLAGS_DEBUG}>
)
set(mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${mbedtls_MbedTLS_mbedcrypto_COMPILE_OPTIONS_C_DEBUG}>")