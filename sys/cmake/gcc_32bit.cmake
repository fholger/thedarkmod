# To compile for 32bit platform on Linux, call CMake like this:
# cmake path/to/source -DCMAKE_TOOLCHAIN_FILE=path/to/source/sys/cmake/gcc_32bit.cmake

string(FIND "${CMAKE_CXX_FLAGS}" "-m32 -msse3" M32_POS_CXX)
if (M32_POS_CXX EQUAL -1)
    set(CMAKE_CXX_FLAGS "-m32 -msse3 ${CMAKE_CXX_FLAGS}" CACHE STRING "" FORCE)
endif()
string(FIND "${CMAKE_C_FLAGS}" "-m32 -msse3" M32_POS_C)
if (M32_POS_C EQUAL -1)
    set(CMAKE_C_FLAGS "-m32 -msse3 ${CMAKE_C_FLAGS}" CACHE STRING "" FORCE)
endif()
