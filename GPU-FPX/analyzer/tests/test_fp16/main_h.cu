#include <iostream>
#include <stdint.h> 
#include <cuda_fp16.h>
using namespace std;
#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
    if (code != cudaSuccess) 
    {   
        fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
        if (abort) exit(code);
    }   
}
__global__ void half_plus1(__half *in_array)
{
    const int idx = threadIdx.x + blockDim.x*blockIdx.x;
    //in_array[idx] = __float2half(__half2float(in_array[idx]) + 1.0);
    in_array[idx] = __hdiv(in_array[idx], 1.5);
}
int main(void)
{
    const int n = 64;
    __half *h_in, *d_in;
    h_in = (__half*) malloc(n*sizeof(__half));
    gpuErrchk( cudaMalloc(&d_in, n*sizeof(__half)) );
    for (int i=0; i<n; i++)
        h_in[i] = __float2half(1.5);
    gpuErrchk( cudaMemcpy(d_in, h_in, n*sizeof(__half), cudaMemcpyHostToDevice) );
    dim3 block_dims(2,1,1);
    dim3 thread_dims(32,1,1);
    half_plus1<<<block_dims, thread_dims>>>(d_in);
    gpuErrchk( cudaPeekAtLastError() );
    gpuErrchk( cudaDeviceSynchronize() );
    gpuErrchk( cudaMemcpy(h_in, d_in, n*sizeof(__half), cudaMemcpyDeviceToHost) );
    for (int i=0; i<n; i++)
    {   
        // if(__half2float(h_in[i]) != 2.5)
        // {
        //     cout<< "Mismatch at " << i << " Expected = 2.5 " << "Actual = " << __half2float(h_in[i]) << endl;
        //     exit(1);
        // }
        cout<<"Actual = " << __half2float(h_in[i]) << endl;
    }    
    //cout << "TEST PASSES" << endl;
    cudaFree(d_in);
    free(h_in);
    return 0;
}
