/* This is a automatically generated test. Do not modify */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

__global__
void compute(float comp, int var_1,float var_2,float var_3,float var_4,float var_5,float var_6,float var_7,float var_8,float var_9,float var_10,float var_11,float var_12) {
  if (comp < +1.4882E-36f / (var_2 / var_3)) {
  if (comp < (-1.3710E-36f * (var_4 * asinf(var_5 - (+1.8810E35f * (-1.7451E-36f - -1.8252E25f)))))) {
    for (int i=0; i < var_1; ++i) {
      comp += (-1.2725E20f - var_6);
if (comp == sinhf((var_7 * (var_8 / (var_9 * +1.3792E36f))))) {
  comp += -1.1554E35f / (var_10 - (var_11 / var_12));
}
}
}
}
   printf("%.17g\n", comp);

}

float* initPointer(float v) {
  float *ret = (float*) malloc(sizeof(float)*10);
  for(int i=0; i < 10; ++i)
    ret[i] = v;
  return ret;
}

int main(int argc, char** argv) {
/* Program variables */

  float tmp_1 = atof(argv[1]);
  int tmp_2 = atoi(argv[2]);
  float tmp_3 = atof(argv[3]);
  float tmp_4 = atof(argv[4]);
  float tmp_5 = atof(argv[5]);
  float tmp_6 = atof(argv[6]);
  float tmp_7 = atof(argv[7]);
  float tmp_8 = atof(argv[8]);
  float tmp_9 = atof(argv[9]);
  float tmp_10 = atof(argv[10]);
  float tmp_11 = atof(argv[11]);
  float tmp_12 = atof(argv[12]);
  float tmp_13 = atof(argv[13]);

  compute<<<1,1>>>(tmp_1,tmp_2,tmp_3,tmp_4,tmp_5,tmp_6,tmp_7,tmp_8,tmp_9,tmp_10,tmp_11,tmp_12,tmp_13);
    cudaError_t error = cudaGetLastError();
    if (error != cudaSuccess) {
        printf("Error: %s\n", cudaGetErrorString(error));
        return 1;
    }
  cudaDeviceSynchronize();

  return 0;
}
