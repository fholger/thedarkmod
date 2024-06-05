# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/tinyformat-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${tinyformat_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${tinyformat_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET tinyformat::tinyformat)
    add_library(tinyformat::tinyformat INTERFACE IMPORTED)
    message(${tinyformat_MESSAGE_MODE} "Conan: Target declared 'tinyformat::tinyformat'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/tinyformat-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()