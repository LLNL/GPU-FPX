
#include <stdio.h>
#include <stdlib.h>


__global__ void dot_prod(float *x, float *y, int size)
{
  float d;
  for (int i=0; i < size; ++i)
  {
    float tmp;
    tmp = x[i]*y[i];
    tmp = (tmp-tmp) / (tmp - tmp); // division by zero, produce NaN
    d += tmp; // d=NaN
  }

  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  if (tid == 0) {
    printf("dot: %f\n", d);
  }
}
int main(int argc, char **argv)
{
  int n = 3;
  int nbytes = n*sizeof(float); 
  float *d_a = 0;
  cudaMalloc(&d_a, nbytes);

  float *data = (float *)malloc(nbytes);
  for (int i=0; i < n; ++i)
  {
    data[i] = (float)(i+1);
  }

  cudaMemcpy((void *)d_a, (void *)data, nbytes, cudaMemcpyHostToDevice);

  printf("Calling kernel\n");
  dot_prod<<<1,1>>>(d_a, d_a, nbytes);
  cudaDeviceSynchronize();
  printf("done\n");

  return 0;
}
