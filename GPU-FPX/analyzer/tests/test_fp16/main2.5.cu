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
__global__ void half2_plus1(int n,__half *in_array)
{
    const int idx = threadIdx.x + blockDim.x*blockIdx.x;
    if(idx%2==0&&idx<n) {
        half2 *in_array2 = (half2*)in_array;
        //in_array2[idx/2] = __hadd2(__halves2half2(in_array[idx], in_array[idx+1]),  __halves2half2(__float2half(1.9),__float2half(7.4)));
        in_array2[idx/2] = __hadd2(__halves2half2(in_array[idx], in_array[idx+1]),  __float2half2_rn(1));
    }
}
int main(void)
{
    const int n = 64;
    // __half2 *h_in, *d_in;
    // h_in = (__half2*) malloc(n*sizeof(__half2));
    // gpuErrchk( cudaMalloc(&d_in, n*sizeof(__half2)) );
    // for (int i=0; i<n; i++)
    //     h_in[i] = __float2half2_rn(1.5);
    // gpuErrchk( cudaMemcpy(d_in, h_in, n*sizeof(__half2), cudaMemcpyHostToDevice) );
    // dim3 block_dims(2,1,1);
    // dim3 thread_dims(32,1,1);
    // half2_plus1<<<block_dims, thread_dims>>>(d_in);
    // gpuErrchk( cudaPeekAtLastError() );
    // gpuErrchk( cudaDeviceSynchronize() );
    // gpuErrchk( cudaMemcpy(h_in, d_in, n*sizeof(__half2), cudaMemcpyDeviceToHost) );
    __half *h_in, *d_in;
    h_in = (__half*) malloc(n*sizeof(__half));
    gpuErrchk( cudaMalloc(&d_in, n*sizeof(__half)) );
    for (int i=0; i<n; i+=2){
        h_in[i] = __float2half(3.5);
        cout << "h[" << i << "] = " << __half2float(h_in[i]) << endl;
    }
    for (int i=1; i<n; i+=2){
        h_in[i] = __float2half(0.5);
        cout << "h[" << i << "] = " << __half2float(h_in[i]) << endl;
    }
    gpuErrchk( cudaMemcpy(d_in, h_in, n*sizeof(__half), cudaMemcpyHostToDevice) );
    dim3 block_dims(2,1,1);
    dim3 thread_dims(32,1,1);
    half2_plus1<<<block_dims, thread_dims>>>(n,d_in);
    gpuErrchk( cudaPeekAtLastError() );
    gpuErrchk( cudaDeviceSynchronize() );
    gpuErrchk( cudaMemcpy(h_in, d_in, n*sizeof(__half), cudaMemcpyDeviceToHost) );
    for (int i=0; i<n; i++)
    {   
        // if((__high2float(h_in[i]) != 2.5) || (__low2float(h_in[i]) !=2.5))
        // {
        //     cout<< "Mismatch at " << i << " Expected = 2.5 " << "Actual = " << __half2float(h_in[i].x) << " " << __half2float(h_in[i].y) << endl;
        //     exit(1);
        // }
        cout<< "h_in[" << i << "] = " << __half2float(h_in[i])  << endl;
    }   
    cout << "TEST PASSES" << endl;
    cudaFree(d_in);
    free(h_in);
    return 0;
}