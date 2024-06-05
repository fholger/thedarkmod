# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/ALSA-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${libalsa_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${ALSA_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET ALSA::ALSA)
    add_library(ALSA::ALSA INTERFACE IMPORTED)
    message(${ALSA_MESSAGE_MODE} "Conan: Target declared 'ALSA::ALSA'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/ALSA-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()