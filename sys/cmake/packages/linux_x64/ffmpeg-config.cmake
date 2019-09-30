set(FFMPEG_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/ThirdParty/artefacts/ffmpeg/include")
set(FFMPEG_LIBRARY_DIR "${PROJECT_SOURCE_DIR}/ThirdParty/artefacts/ffmpeg/lib/lnx64_s_gcc5_rel_stdcpp")
set(FFMPEG_LIBRARIES
        "${FFMPEG_LIBRARY_DIR}/libavformat.a"
        "${FFMPEG_LIBRARY_DIR}/libavcodec.a"
        "${FFMPEG_LIBRARY_DIR}/libavutil.a"
        "${FFMPEG_LIBRARY_DIR}/libswresample.a"
        "${FFMPEG_LIBRARY_DIR}/libswscale.a"
)
