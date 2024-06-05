# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/fltk-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${fltk_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${fltk_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET fltk::fltk)
    add_library(fltk::fltk INTERFACE IMPORTED)
    message(${fltk_MESSAGE_MODE} "Conan: Target declared 'fltk::fltk'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/fltk-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()