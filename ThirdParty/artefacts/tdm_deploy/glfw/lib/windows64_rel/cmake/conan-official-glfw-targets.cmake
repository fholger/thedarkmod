if(TARGET glfw::glfw AND NOT TARGET glfw)
    add_library(glfw INTERFACE IMPORTED)
    set_property(TARGET glfw PROPERTY INTERFACE_LINK_LIBRARIES glfw::glfw)
endif()
