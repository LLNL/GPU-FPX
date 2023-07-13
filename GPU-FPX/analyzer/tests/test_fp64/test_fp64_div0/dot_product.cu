
#include <stdio.h>

// __device__ void mul(double a, double b, double *res)
// {
//   *res = a * b;
//   // NaN
//   *res = (*res)-(*res) / (*res)-(*res); 
// }

__global__ void dot_prod(double *x, double *y, int size)
{
  double d;
  for (int i=0; i < size; ++i)
  {
    double tmp;
    //mul(x[i], y[i], &tmp);
    tmp = y[i]*double(0.0);
 //   printf("first tmp is %lf\n",tmp);
  // NaN
    //tmp = (tmp)-(tmp) / (tmp)-(tmp); 
    //tmp = tmp / (tmp - tmp);
    tmp = x[i] / tmp;
//    printf("second tmp is %lf\n",tmp);
    d += tmp;
  }

  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  if (tid == 0) {
    printf("dot: %f\n", d);
  }
}
