message(STATUS "Conan: Using CMakeDeps conandeps_legacy.cmake aggregator via include()")
message(STATUS "Conan: It is recommended to use explicit find_package() per dependency instead")

find_package(tinyformat)
find_package(doctest)
find_package(tracy)
find_package(minizip)
find_package(CURL)
find_package(MbedTLS)
find_package(ffmpeg)
find_package(Vorbis)
find_package(Ogg)
find_package(fltk)
find_package(JPEG)
find_package(PNG)
find_package(ZLIB)
find_package(blake2)
find_package(glfw3)
find_package(OpenAL)
find_package(pugixml)

set(CONANDEPS_LEGACY  tinyformat::tinyformat  doctest::doctest  tracy::tracy  minizip::minizip  CURL::libcurl  MbedTLS::mbedtls  ffmpeg::ffmpeg  vorbis::vorbis  Ogg::ogg  fltk::fltk  JPEG::JPEG  PNG::PNG  ZLIB::ZLIB  blake2::blake2  glfw  OpenAL::OpenAL  pugixml::pugixml )