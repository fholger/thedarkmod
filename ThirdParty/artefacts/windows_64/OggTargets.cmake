# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/Ogg-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${ogg_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${Ogg_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET Ogg::ogg)
    add_library(Ogg::ogg INTERFACE IMPORTED)
    message(${Ogg_MESSAGE_MODE} "Conan: Target declared 'Ogg::ogg'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/Ogg-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()