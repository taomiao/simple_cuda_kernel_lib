#include <stdio.h>
#include "cuda_runtime.h"
__global__ void simple_kernel(){
    printf("running simple kernel\n");
}

extern "C" void call_simple(){
    printf("before call kernel\n");
    simple_kernel<<<1, 1>>>();
    cudaDeviceSynchronize();
    printf("after call kernel\n");
}