cmake_minimum_required(VERSION 3.12)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/sys/cmake" "${CMAKE_SOURCE_DIR}/sys/cmake/ThirdParty")
include(ucm)
include(PrecompiledHeader)

project(TheDarkMod VERSION 2.08)
add_executable(TheDarkMod)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# TODO: actual revision number
set(SVNVERSION "99999")
configure_file("idlib/svnversion.cmake.h" "${PROJECT_SOURCE_DIR}/idlib/svnversion.h" @ONLY)

# gather list of source files
ucm_add_dirs(
		"cm"
		"framework"
		"game"
		"idlib"
		"renderer"
		"sound"
		"tests"
		"TypeInfo"
		"ui"
		"tools/compilers"
		TO TDM_SOURCE_FILES RECURSIVE
)
ucm_add_files("sys/sys_local.cpp" "sys/sys_local.h" "sys/sys_public.h" TO TDM_SOURCE_FILES)

if (UNIX)
	ucm_add_dirs("sys/linux" "sys/posix" TO TDM_SOURCE_FILES RECURSIVE)
    ucm_add_files("tools/guied/GEWindowWrapper_stub.cpp" TO TDM_SOURCE_FILES)
elseif (WIN32)
	ucm_add_dirs("sys/win32" TO TDM_SOURCE_FILES RECURSIVE)
	ucm_add_files("tools/guied/GEWindowWrapper_stub.cpp" TO TDM_SOURCE_FILES)
	ucm_remove_files("renderer/glad_glx.c" FROM TDM_SOURCE_FILES)
	add_compile_definitions(NO_MFC)
endif()

# blacklist dead code files that unfortunately still hang around the repository
ucm_remove_directories("framework/async" FROM TDM_SOURCE_FILES)
ucm_remove_files(
		"TypeInfo/main.cpp"
		"game/Game_network.cpp"
		"game/MultiplayerGame.cpp"
		"game/gamesys/Callbacks.cpp"
		"game/gamesys/TypeInfo.cpp"
		"idlib/ParallelJobList.cpp"
		"idlib/math/Simd_AltiVec.cpp"
		"idlib/precompiled.cpp"
		"idlib/bv/Frustum_gcc.cpp"
		"renderer/draw_exp.cpp"
        "sys/win32/win_gamma.cpp"
		"tools/compilers/dmap/optimize_gcc.cpp"
		FROM TDM_SOURCE_FILES
)

target_sources(TheDarkMod PRIVATE ${TDM_SOURCE_FILES})

# configure precompiled header
# note TypeInfo.cpp must be excluded from precompiled header because it uses some dirty hacks
ucm_remove_files("idlib/precompiled.cpp" "game/gamesys/TypeInfo.cpp" FROM TDM_SOURCE_FILES)
add_msvc_precompiled_header("precompiled.h" "idlib/precompiled.cpp" TDM_SOURCE_FILES)

add_compile_definitions(
		"ExtLibs="
		IL_STATIC_LIB
		__DOOM__
		CURL_STATICLIB
		AL_LIBTYPE_STATIC
)

if (UNIX)
	# configure sensible warnings
	add_compile_options(
			-Wall
			-Wno-unknown-pragmas            # MSVC specific pragmas
			-Wno-unused-variable            # too many
			-Wno-unused-but-set-variable
			-Wno-sign-compare               # in particular, int/size_t conversions
			-Wno-class-memaccess            # memcpy into custom structs
	)
	# configure other compile options
	add_compile_options(
			-pipe
			-fno-strict-aliasing
			-fmessage-length=0
			-fvisibility=hidden
			-fno-unsafe-math-optimizations
	)
	# ffmpeg dep was compiled without -fPIC, so need to disable on 64bit builds
	if (CMAKE_SIZEOF_VOID_P EQUAL 8)
		add_compile_options(-no-pie)
	endif()
	# ensure threading support in X
	add_compile_definitions(XTHREADS)
elseif (MSVC)
	add_compile_definitions("WIN32" _WINDOWS
			_CRT_SECURE_NO_DEPRECATE
			_CRT_NONSTDC_NO_DEPRECATE
			_ALLOW_KEYWORD_MACROS
			NO_WARN_MBCS_MFC_DEPRECATION
			_MBCS
			)
	add_compile_options("/MP")
	ucm_set_runtime(STATIC)
	set(PACKAGE_CONFIG_PATH "${PROJECT_SOURCE_DIR}/sys/cmake/packages/vc15_x64")
endif()

find_package(ZLIB REQUIRED HINTS ${PACKAGE_CONFIG_PATH})
find_package(CURL REQUIRED HINTS ${PACKAGE_CONFIG_PATH})
find_package(OPENAL REQUIRED HINTS ${PACKAGE_CONFIG_PATH})
find_package(OGG REQUIRED HINTS ${PACKAGE_CONFIG_PATH})
find_package(VORBIS REQUIRED HINTS ${PACKAGE_CONFIG_PATH})
find_package(DEVIL REQUIRED HINTS ${PACKAGE_CONFIG_PATH})
find_package(JPEG REQUIRED HINTS ${PACKAGE_CONFIG_PATH})
find_package(FFMPEG REQUIRED HINTS ${PACKAGE_CONFIG_PATH})
find_package(PUGIXML REQUIRED HINTS ${PACKAGE_CONFIG_PATH})
find_package(PNG REQUIRED HINTS ${PACKAGE_CONFIG_PATH})
find_package(MBEDTLS REQUIRED HINTS ${PACKAGE_CONFIG_PATH})

include_directories(
		"${PROJECT_SOURCE_DIR}"
		"${PROJECT_SOURCE_DIR}/idlib"
		"${PROJECT_SOURCE_DIR}/framework"
		"${PROJECT_SOURCE_DIR}/ThirdParty/artefacts/doctest/include"
		${ZLIB_INCLUDE_DIRS}
		${CURL_INCLUDE_DIRS}
		${OPENAL_INCLUDE_DIRS}
		${OGG_INCLUDE_DIRS}
		${VORBIS_INCLUDE_DIRS}
		${DEVIL_INCLUDE_DIRS}
		${JPEG_INCLUDE_DIRS}
		${FFMPEG_INCLUDE_DIRS}
		${PUGIXML_INCLUDE_DIRS}
		${PNG_INCLUDE_DIRS}
		${MBEDTLS_INCLUDE_DIRS}
)

target_link_libraries(TheDarkMod
    ${ZLIB_LIBRARIES}
    ${CURL_LIBRARIES}
    ${OPENAL_LIBRARIES}
    ${OGG_LIBRARIES}
    ${VORBIS_LIBRARIES}
    ${DEVIL_LIBRARIES}
    ${JPEG_LIBRARIES}
    ${FFMPEG_LIBRARIES}
    ${PUGIXML_LIBRARIES}
    ${PNG_LIBRARIES}
    ${MBEDTLS_LIBRARIES}
)

if (WIN32)
	target_link_libraries(TheDarkMod ws2_32 iphlpapi winmm bcrypt dinput8 dbghelp)
	set_target_properties(TheDarkMod PROPERTIES WIN32_EXECUTABLE TRUE)
endif()
