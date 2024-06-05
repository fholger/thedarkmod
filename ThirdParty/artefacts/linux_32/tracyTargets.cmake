# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/tracy-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${tracy_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${tracy_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET tracy::tracy)
    add_library(tracy::tracy INTERFACE IMPORTED)
    message(${tracy_MESSAGE_MODE} "Conan: Target declared 'tracy::tracy'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/tracy-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()