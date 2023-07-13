/* This is a automatically generated test. Do not modify */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

__global__
void compute(float comp, int var_1,int var_2,float var_3,float var_4,float var_5,float var_6,float* var_7,float var_8,float var_9,float var_10) {
if (comp <= asinf(+1.3463E34f)) {
  comp += (var_3 + sinhf(-0.0f));
for (int i=0; i < var_1; ++i) {
  comp += ldexpf(atan2f(+1.5696E-42f, var_4 * var_5 - asinf(+1.2147E35f)), 2);
comp += acosf(logf((+1.6666E-36f / -1.1833E-36f + var_6 + +1.8570E35f)));
}
for (int i=0; i < var_2; ++i) {
  var_7[i] = (var_8 * ceilf(var_9 + logf(var_10 - -1.7568E-37f + -1.7043E26f)));
comp += var_7[i] - floorf(fabsf(+1.2484E35f));
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
  int tmp_3 = atoi(argv[3]);
  float tmp_4 = atof(argv[4]);
  float tmp_5 = atof(argv[5]);
  float tmp_6 = atof(argv[6]);
  float tmp_7 = atof(argv[7]);
  float* tmp_8 = initPointer( atof(argv[8]) );
  float tmp_9 = atof(argv[9]);
  float tmp_10 = atof(argv[10]);
  float tmp_11 = atof(argv[11]);

  compute<<<1,1>>>(tmp_1,tmp_2,tmp_3,tmp_4,tmp_5,tmp_6,tmp_7,tmp_8,tmp_9,tmp_10,tmp_11);
  cudaDeviceSynchronize();

  return 0;
}
