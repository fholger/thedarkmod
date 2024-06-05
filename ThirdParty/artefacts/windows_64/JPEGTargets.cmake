# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/JPEG-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${libjpeg_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${JPEG_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET JPEG::JPEG)
    add_library(JPEG::JPEG INTERFACE IMPORTED)
    message(${JPEG_MESSAGE_MODE} "Conan: Target declared 'JPEG::JPEG'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/JPEG-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()