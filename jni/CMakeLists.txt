cmake_minimum_required(VERSION 3.10.2)

# Global flag para alineación 16KB (Android 15+) obligatorio
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,max-page-size=16384")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -fPIC")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -fPIC")

project(official_opus_build)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# 1. Opus Oficial
set(OPUS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../opus)
include_directories(
    ${OPUS_DIR}/include 
    ${OPUS_DIR}/src 
    ${OPUS_DIR}/celt 
    ${OPUS_DIR}/silk
    ${OPUS_DIR}/silk/float
)

# Fuentes de CELT (sin duplicados)
file(GLOB CELT_SOURCES "${OPUS_DIR}/celt/*.c")
list(FILTER CELT_SOURCES EXCLUDE REGEX ".*dump_.*|.*_demo.c|mini_kfft.c")

# Fuentes de SILK (sin duplicados)
file(GLOB SILK_SOURCES "${OPUS_DIR}/silk/*.c")
file(GLOB SILK_FLOAT_SOURCES "${OPUS_DIR}/silk/float/*.c")

# Fuentes de SRC (sin herramientas de comparación ni main)
file(GLOB SRC_SOURCES "${OPUS_DIR}/src/*.c")
list(FILTER SRC_SOURCES EXCLUDE REGEX ".*compare.c|repacketizer_demo.c|opus_demo.c")

add_library(opus SHARED 
    ${CELT_SOURCES}
    ${SILK_SOURCES}
    ${SILK_FLOAT_SOURCES}
    ${SRC_SOURCES}
)
target_compile_definitions(opus PRIVATE OPUS_BUILD HAVE_CONFIG_H)

# 2. libopusenc Oficial (Arreglado)
set(ENC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../libopusenc)
include_directories(${ENC_DIR}/include ${ENC_DIR}/src)

file(GLOB ENC_SOURCES "${ENC_DIR}/src/*.c")
add_library(opusenc SHARED ${ENC_SOURCES})
target_compile_definitions(opusenc PRIVATE 
    OUTSIDE_SPEEX 
    RANDOM_PREFIX=opusenc_random
    PACKAGE_NAME="libopusenc"
    PACKAGE_VERSION="0.2.1"
)
target_link_libraries(opusenc opus)

# 3. Nuestro Wrapper JNI
add_library(easyopus SHARED
    CodecOpus.cpp
    easyopus.cpp
    SamplesConverter.cpp
)

find_library(log-lib log)
target_link_libraries(easyopus opus opusenc ${log-lib})
