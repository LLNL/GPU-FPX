
#include <stdio.h>

// __device__ void mul(float a, float b, float *res)
// {
//   *res = a * b;
//   // Overflow

// #ifdef FPC_POSITIVE_OVERFLOW
//   *res = (*res) * 1e38;
// #else
//   *res = (*res) * 1e38;
// #endif
// }

__global__ void dot_prod(float *x, float *y, int size)
{
  float d;
  for (int i=0; i < size; ++i)
  {
    float tmp;
    // mul(x[i], y[i], &tmp);
    tmp = x[i]*y[i];
  // Overflow

//  #ifdef FPC_POSITIVE_OVERFLOW
 //   tmp = (tmp) * 1e38;
 // #else
    tmp = tmp * 1e38;
 // #endif
    d += tmp;
  }

  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  if (tid == 0) {
    printf("dot: %f\n", d);
  }
}
