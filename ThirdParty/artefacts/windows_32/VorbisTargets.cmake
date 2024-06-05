# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/Vorbis-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${vorbis_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${Vorbis_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET vorbis::vorbis)
    add_library(vorbis::vorbis INTERFACE IMPORTED)
    message(${Vorbis_MESSAGE_MODE} "Conan: Target declared 'vorbis::vorbis'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/Vorbis-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()