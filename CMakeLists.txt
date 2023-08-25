cmake_minimum_required(VERSION 3.15)

project(nerf_kernels VERSION 1.0.0 LANGUAGES CXX CUDA)

set(CMAKE_CUDA_ARCHITECTURES 75)
enable_language(CUDA)

find_package(CUDA REQUIRED)
message(STATUS "cuda version: " ${CUDA_VERSION_STRING})
message(STATUS ${CUDA_INCLUDE_DIRS})
include_directories(${CUDA_INCLUDE_DIRS})

include_directories(include)

add_library(
    nerf_kernels
    STATIC
    src/simple.cu
)

set_target_properties(nerf_kernels PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(nerf_kernels
                       PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
set_target_properties(nerf_kernels PROPERTIES PUBLIC_HEADER include/simple.h)
target_link_libraries(nerf_kernels ${CUDA_LIBRARIES})

install(TARGETS nerf_kernels
        EXPORT MyLibTargets 
        LIBRARY DESTINATION lib  # 动态库安装路径
        ARCHIVE DESTINATION lib  # 静态库安装路径
        RUNTIME DESTINATION bin  # 可执行文件安装路径
        PUBLIC_HEADER DESTINATION include  # 头文件安装路径
        )

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
        MyLibTargets.cmake
        VERSION ${PACKAGE_VERSION}
        COMPATIBILITY AnyNewerVersion  # 表示该函数库向下兼容
        )

install(EXPORT MyLibTargets
        FILE MyLibTargets.cmake
        NAMESPACE MyLib::
        DESTINATION lib/cmake/MyLib
        )

add_executable(
    interface
    src/interface.cpp
)
target_link_libraries(interface nerf_kernels)
