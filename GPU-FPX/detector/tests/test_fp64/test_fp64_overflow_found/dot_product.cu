
#include <stdio.h>

// __device__ void mul(double a, double b, double *res)
// {
//   *res = a * b;
//   // Overflow

// #ifdef FPC_POSITIVE_OVERFLOW
//   *res = (*res) * 1e308;
// #else
//   *res = (*res) * 1e308;
// #endif
// }

__global__ void dot_prod(double *x, double *y, int size)
{
  double d;
  for (int i=0; i < size; ++i)
  {
    double tmp;
    //mul(x[i], y[i], &tmp);
     tmp = x[i]*y[i];
  // Overflow

//  #ifdef FPC_POSITIVE_OVERFLOW
 //   tmp = (tmp) * 1e308;
 // #else
    tmp = tmp * 1e308;
 // #endif
    d += tmp;
  }

  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  if (tid == 0) {
    printf("dot: %f\n", d);
  }
}
