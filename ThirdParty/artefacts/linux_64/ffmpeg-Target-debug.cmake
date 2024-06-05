# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(ffmpeg_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(ffmpeg_FRAMEWORKS_FOUND_DEBUG "${ffmpeg_FRAMEWORKS_DEBUG}" "${ffmpeg_FRAMEWORK_DIRS_DEBUG}")

set(ffmpeg_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET ffmpeg_DEPS_TARGET)
    add_library(ffmpeg_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET ffmpeg_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${ffmpeg_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${ffmpeg_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:ffmpeg::avutil;ffmpeg::avcodec;ffmpeg::swresample>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### ffmpeg_DEPS_TARGET to all of them
conan_package_library_targets("${ffmpeg_LIBS_DEBUG}"    # libraries
                              "${ffmpeg_LIB_DIRS_DEBUG}" # package_libdir
                              "${ffmpeg_BIN_DIRS_DEBUG}" # package_bindir
                              "${ffmpeg_LIBRARY_TYPE_DEBUG}"
                              "${ffmpeg_IS_HOST_WINDOWS_DEBUG}"
                              ffmpeg_DEPS_TARGET
                              ffmpeg_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "ffmpeg"    # package_name
                              "${ffmpeg_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${ffmpeg_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Debug ########################################

    ########## COMPONENT ffmpeg::avformat #############

        set(ffmpeg_ffmpeg_avformat_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(ffmpeg_ffmpeg_avformat_FRAMEWORKS_FOUND_DEBUG "${ffmpeg_ffmpeg_avformat_FRAMEWORKS_DEBUG}" "${ffmpeg_ffmpeg_avformat_FRAMEWORK_DIRS_DEBUG}")

        set(ffmpeg_ffmpeg_avformat_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET ffmpeg_ffmpeg_avformat_DEPS_TARGET)
            add_library(ffmpeg_ffmpeg_avformat_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET ffmpeg_ffmpeg_avformat_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avformat_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avformat_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avformat_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'ffmpeg_ffmpeg_avformat_DEPS_TARGET' to all of them
        conan_package_library_targets("${ffmpeg_ffmpeg_avformat_LIBS_DEBUG}"
                              "${ffmpeg_ffmpeg_avformat_LIB_DIRS_DEBUG}"
                              "${ffmpeg_ffmpeg_avformat_BIN_DIRS_DEBUG}" # package_bindir
                              "${ffmpeg_ffmpeg_avformat_LIBRARY_TYPE_DEBUG}"
                              "${ffmpeg_ffmpeg_avformat_IS_HOST_WINDOWS_DEBUG}"
                              ffmpeg_ffmpeg_avformat_DEPS_TARGET
                              ffmpeg_ffmpeg_avformat_LIBRARIES_TARGETS
                              "_DEBUG"
                              "ffmpeg_ffmpeg_avformat"
                              "${ffmpeg_ffmpeg_avformat_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET ffmpeg::avformat
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avformat_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avformat_LIBRARIES_TARGETS}>
                     )

        if("${ffmpeg_ffmpeg_avformat_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET ffmpeg::avformat
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         ffmpeg_ffmpeg_avformat_DEPS_TARGET)
        endif()

        set_property(TARGET ffmpeg::avformat APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avformat_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET ffmpeg::avformat APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avformat_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET ffmpeg::avformat APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avformat_LIB_DIRS_DEBUG}>)
        set_property(TARGET ffmpeg::avformat APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avformat_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET ffmpeg::avformat APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avformat_COMPILE_OPTIONS_DEBUG}>)

    ########## COMPONENT ffmpeg::avcodec #############

        set(ffmpeg_ffmpeg_avcodec_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(ffmpeg_ffmpeg_avcodec_FRAMEWORKS_FOUND_DEBUG "${ffmpeg_ffmpeg_avcodec_FRAMEWORKS_DEBUG}" "${ffmpeg_ffmpeg_avcodec_FRAMEWORK_DIRS_DEBUG}")

        set(ffmpeg_ffmpeg_avcodec_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET ffmpeg_ffmpeg_avcodec_DEPS_TARGET)
            add_library(ffmpeg_ffmpeg_avcodec_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET ffmpeg_ffmpeg_avcodec_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avcodec_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avcodec_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avcodec_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'ffmpeg_ffmpeg_avcodec_DEPS_TARGET' to all of them
        conan_package_library_targets("${ffmpeg_ffmpeg_avcodec_LIBS_DEBUG}"
                              "${ffmpeg_ffmpeg_avcodec_LIB_DIRS_DEBUG}"
                              "${ffmpeg_ffmpeg_avcodec_BIN_DIRS_DEBUG}" # package_bindir
                              "${ffmpeg_ffmpeg_avcodec_LIBRARY_TYPE_DEBUG}"
                              "${ffmpeg_ffmpeg_avcodec_IS_HOST_WINDOWS_DEBUG}"
                              ffmpeg_ffmpeg_avcodec_DEPS_TARGET
                              ffmpeg_ffmpeg_avcodec_LIBRARIES_TARGETS
                              "_DEBUG"
                              "ffmpeg_ffmpeg_avcodec"
                              "${ffmpeg_ffmpeg_avcodec_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET ffmpeg::avcodec
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avcodec_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avcodec_LIBRARIES_TARGETS}>
                     )

        if("${ffmpeg_ffmpeg_avcodec_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET ffmpeg::avcodec
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         ffmpeg_ffmpeg_avcodec_DEPS_TARGET)
        endif()

        set_property(TARGET ffmpeg::avcodec APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avcodec_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET ffmpeg::avcodec APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avcodec_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET ffmpeg::avcodec APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avcodec_LIB_DIRS_DEBUG}>)
        set_property(TARGET ffmpeg::avcodec APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avcodec_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET ffmpeg::avcodec APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avcodec_COMPILE_OPTIONS_DEBUG}>)

    ########## COMPONENT ffmpeg::swresample #############

        set(ffmpeg_ffmpeg_swresample_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(ffmpeg_ffmpeg_swresample_FRAMEWORKS_FOUND_DEBUG "${ffmpeg_ffmpeg_swresample_FRAMEWORKS_DEBUG}" "${ffmpeg_ffmpeg_swresample_FRAMEWORK_DIRS_DEBUG}")

        set(ffmpeg_ffmpeg_swresample_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET ffmpeg_ffmpeg_swresample_DEPS_TARGET)
            add_library(ffmpeg_ffmpeg_swresample_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET ffmpeg_ffmpeg_swresample_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swresample_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swresample_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swresample_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'ffmpeg_ffmpeg_swresample_DEPS_TARGET' to all of them
        conan_package_library_targets("${ffmpeg_ffmpeg_swresample_LIBS_DEBUG}"
                              "${ffmpeg_ffmpeg_swresample_LIB_DIRS_DEBUG}"
                              "${ffmpeg_ffmpeg_swresample_BIN_DIRS_DEBUG}" # package_bindir
                              "${ffmpeg_ffmpeg_swresample_LIBRARY_TYPE_DEBUG}"
                              "${ffmpeg_ffmpeg_swresample_IS_HOST_WINDOWS_DEBUG}"
                              ffmpeg_ffmpeg_swresample_DEPS_TARGET
                              ffmpeg_ffmpeg_swresample_LIBRARIES_TARGETS
                              "_DEBUG"
                              "ffmpeg_ffmpeg_swresample"
                              "${ffmpeg_ffmpeg_swresample_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET ffmpeg::swresample
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swresample_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swresample_LIBRARIES_TARGETS}>
                     )

        if("${ffmpeg_ffmpeg_swresample_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET ffmpeg::swresample
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         ffmpeg_ffmpeg_swresample_DEPS_TARGET)
        endif()

        set_property(TARGET ffmpeg::swresample APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swresample_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET ffmpeg::swresample APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swresample_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET ffmpeg::swresample APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swresample_LIB_DIRS_DEBUG}>)
        set_property(TARGET ffmpeg::swresample APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swresample_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET ffmpeg::swresample APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swresample_COMPILE_OPTIONS_DEBUG}>)

    ########## COMPONENT ffmpeg::swscale #############

        set(ffmpeg_ffmpeg_swscale_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(ffmpeg_ffmpeg_swscale_FRAMEWORKS_FOUND_DEBUG "${ffmpeg_ffmpeg_swscale_FRAMEWORKS_DEBUG}" "${ffmpeg_ffmpeg_swscale_FRAMEWORK_DIRS_DEBUG}")

        set(ffmpeg_ffmpeg_swscale_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET ffmpeg_ffmpeg_swscale_DEPS_TARGET)
            add_library(ffmpeg_ffmpeg_swscale_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET ffmpeg_ffmpeg_swscale_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swscale_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swscale_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swscale_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'ffmpeg_ffmpeg_swscale_DEPS_TARGET' to all of them
        conan_package_library_targets("${ffmpeg_ffmpeg_swscale_LIBS_DEBUG}"
                              "${ffmpeg_ffmpeg_swscale_LIB_DIRS_DEBUG}"
                              "${ffmpeg_ffmpeg_swscale_BIN_DIRS_DEBUG}" # package_bindir
                              "${ffmpeg_ffmpeg_swscale_LIBRARY_TYPE_DEBUG}"
                              "${ffmpeg_ffmpeg_swscale_IS_HOST_WINDOWS_DEBUG}"
                              ffmpeg_ffmpeg_swscale_DEPS_TARGET
                              ffmpeg_ffmpeg_swscale_LIBRARIES_TARGETS
                              "_DEBUG"
                              "ffmpeg_ffmpeg_swscale"
                              "${ffmpeg_ffmpeg_swscale_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET ffmpeg::swscale
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swscale_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swscale_LIBRARIES_TARGETS}>
                     )

        if("${ffmpeg_ffmpeg_swscale_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET ffmpeg::swscale
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         ffmpeg_ffmpeg_swscale_DEPS_TARGET)
        endif()

        set_property(TARGET ffmpeg::swscale APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swscale_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET ffmpeg::swscale APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swscale_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET ffmpeg::swscale APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swscale_LIB_DIRS_DEBUG}>)
        set_property(TARGET ffmpeg::swscale APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swscale_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET ffmpeg::swscale APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_swscale_COMPILE_OPTIONS_DEBUG}>)

    ########## COMPONENT ffmpeg::avutil #############

        set(ffmpeg_ffmpeg_avutil_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(ffmpeg_ffmpeg_avutil_FRAMEWORKS_FOUND_DEBUG "${ffmpeg_ffmpeg_avutil_FRAMEWORKS_DEBUG}" "${ffmpeg_ffmpeg_avutil_FRAMEWORK_DIRS_DEBUG}")

        set(ffmpeg_ffmpeg_avutil_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET ffmpeg_ffmpeg_avutil_DEPS_TARGET)
            add_library(ffmpeg_ffmpeg_avutil_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET ffmpeg_ffmpeg_avutil_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avutil_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avutil_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avutil_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'ffmpeg_ffmpeg_avutil_DEPS_TARGET' to all of them
        conan_package_library_targets("${ffmpeg_ffmpeg_avutil_LIBS_DEBUG}"
                              "${ffmpeg_ffmpeg_avutil_LIB_DIRS_DEBUG}"
                              "${ffmpeg_ffmpeg_avutil_BIN_DIRS_DEBUG}" # package_bindir
                              "${ffmpeg_ffmpeg_avutil_LIBRARY_TYPE_DEBUG}"
                              "${ffmpeg_ffmpeg_avutil_IS_HOST_WINDOWS_DEBUG}"
                              ffmpeg_ffmpeg_avutil_DEPS_TARGET
                              ffmpeg_ffmpeg_avutil_LIBRARIES_TARGETS
                              "_DEBUG"
                              "ffmpeg_ffmpeg_avutil"
                              "${ffmpeg_ffmpeg_avutil_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET ffmpeg::avutil
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avutil_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avutil_LIBRARIES_TARGETS}>
                     )

        if("${ffmpeg_ffmpeg_avutil_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET ffmpeg::avutil
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         ffmpeg_ffmpeg_avutil_DEPS_TARGET)
        endif()

        set_property(TARGET ffmpeg::avutil APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avutil_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET ffmpeg::avutil APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avutil_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET ffmpeg::avutil APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avutil_LIB_DIRS_DEBUG}>)
        set_property(TARGET ffmpeg::avutil APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avutil_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET ffmpeg::avutil APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${ffmpeg_ffmpeg_avutil_COMPILE_OPTIONS_DEBUG}>)

    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET ffmpeg::ffmpeg APPEND PROPERTY INTERFACE_LINK_LIBRARIES ffmpeg::avformat)
    set_property(TARGET ffmpeg::ffmpeg APPEND PROPERTY INTERFACE_LINK_LIBRARIES ffmpeg::avcodec)
    set_property(TARGET ffmpeg::ffmpeg APPEND PROPERTY INTERFACE_LINK_LIBRARIES ffmpeg::swresample)
    set_property(TARGET ffmpeg::ffmpeg APPEND PROPERTY INTERFACE_LINK_LIBRARIES ffmpeg::swscale)
    set_property(TARGET ffmpeg::ffmpeg APPEND PROPERTY INTERFACE_LINK_LIBRARIES ffmpeg::avutil)

########## For the modules (FindXXX)
set(ffmpeg_LIBRARIES_DEBUG ffmpeg::ffmpeg)
