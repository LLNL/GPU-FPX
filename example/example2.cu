#include <stdio.h>
#include <stdlib.h>
#include <math.h>

__global__ void example(float *x, float *y, int nfloat)
{
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  float d;
  float tmp;
  int   i=0; // simplify example, removing 'for'

  tmp = x[i] / (x[i]-y[i]);
  d = sqrt(tmp);

  tid = blockIdx.x * blockDim.x + threadIdx.x;
  if (tid == 0) {
    printf("dot: %f\n", d);
  }
}

int main(int argc, char **argv)
{
  int nfloat = 2;
  int nbytes = nfloat*sizeof(float);
  float *d_a = 0;
  cudaMalloc(&d_a, nbytes);

  float *data = (float *)malloc(nbytes);
  for (int i=0; i < nfloat; ++i)
  {
    data[i] = (float)(i+1);
  }

  cudaMemcpy((void *)d_a, (void *)data, nbytes, cudaMemcpyHostToDevice);
  printf("Calling kernel\n");

  example<<<1,1>>>(d_a, d_a, nfloat);

  cudaDeviceSynchronize();
  printf("done\n");

  return 0;
}
