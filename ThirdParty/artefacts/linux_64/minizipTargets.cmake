# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/minizip-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${minizip_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${minizip_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET minizip::minizip)
    add_library(minizip::minizip INTERFACE IMPORTED)
    message(${minizip_MESSAGE_MODE} "Conan: Target declared 'minizip::minizip'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/minizip-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()