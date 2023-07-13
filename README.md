# GPU-FPX: A Low-Overhead tool for Floating-Point Exception Detection in NVIDIA GPUs
GPU-FPX is a tool based on [NVBit](https://github.com/NVlabs/NVBit.git) that detects and analyzes floating-point exceptions on NVIDIA GPUs through binary instrumentation. Its purpose is to detect and report the occurances of floating-point exceptions during numerical computations, offering efficient location detections and exception flow. GPU-FPX achieves exceptional performance, being 16× faster than comparable prior tools, such as [BinFPE](https://github.com/LLNL/BinFPE). 

To reproduce the experiments in the paper, see the [Benchmarks](benchmarks/README.md) section.

## Build
GPU-FPX is under the [license agreement of NVBit](https://github.com/NVlabs/NVBit/blob/master/EULA.txt), so we construct the code by providing `.patch` files. 

There are two components in GPU-FPX:
- A `detector` to detect the floating point exceptions and report their locations;
- An `analyzer` which can display how an exception flows within one instruction. This may help debug and fix the exceptions in the program being analyzed.

To build both components, just run 
the following commands:
```bash
git clone http://github/LLNL/GPU-FPX
cd GPU-FPX
make
```
You can also run 
```bash
make detector 
make analyzer
```
to build them separately. 

This will generate two shared objects
```
./nvbit_release/tools/GPU-FPX/analyzer/analyzer.so
```
and 
```
./nvbit_release/tools/GPU-FPX/detector/detector.so
```
which can be loaded when executing your programs. 

## Usage
To use our tools, you need to load the shared objects with `LD_PRELOAD` while running your programs. 
For example, if you want to detect exceptions for your GPU programs, just run 
```bash
LD_PRELOAD=/your/path/to/GPU-FPX/nvbit_release/tools/GPU-FPX/detector/detector.so ./your/program
```
## Getting start example
We provide a simple example to illustrate how to use GPU-FPX to detect and analyze the exceptions. 
All the example codes can be find in [example](example/).
#### Create a simple GPU program
Here we create a GPU program to compute the dot product, you can name it as `dot-prod.cu`

```CUDA
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
```

Observe that there is a division by zero operation on line 13 resulting in a NaN in the final result. 
#### Compiling and running it
```bash
nvcc --generate-line-info dot-prod.cu -o dot-prod
./dot-prod
```
It will output
```
./dot-prod
Calling kernel
dot: nan
done
```
#### Using the`detector`
```bash
LD_PRELOAD=/your/path/to/GPU-FPX/nvbit_release/tools/GPU-FPX/detector/detector.so ./dot-prod
```
It will generate exceptional report, we paste some segments here:
```
#GPU-FPX LOC-EXCEP INFO: in kernel [dot_prod], DIV0 found @ /home/xinyi/gpufpx-docker/example/dot-prod.cu:13 [FP32]
#GPU-FPX LOC-EXCEP INFO: in kernel [dot_prod], NaN found @ /home/xinyi/gpufpx-docker/example/dot-prod.cu:13 [FP32]
dot: nan
#GPU-FPX LOC-EXCEP INFO: in kernel [dot_prod], NaN found @ /home/xinyi/gpufpx-docker/example/dot-prod.cu:21 [FP32]
#GPU-FPX LOC-EXCEP INFO: in kernel [dot_prod], NaN found @ /home/xinyi/gpufpx-docker/example/dot-prod.cu:14 [FP32]
```
We can see it successfully detects the division by zero operation on line 13. 

#### Using `analyzer`
```bash
LD_PRELOAD=/your/path/to/GPU-FPX/nvbit_release/tools/GPU-FPX/analyzer/analyzer.so ./dot-prod
```
We paste some analyzer segments here: 
```
#GPU-FPX-ANA APPEAR : INF appear at the destination  @ /home/xinyi/gpufpx-docker/example/dot-prod.cu:13 Instruction: MUFU.RCP R0, R10 ; We have 2 registers in total. Register 0 is INF. Register 1 is VAL.
#GPU-FPX-ANA APPEAR : NaN appear at the destination  @ /home/xinyi/gpufpx-docker/example/dot-prod.cu:13 Instruction: FFMA R9, -R10, R0, 1 ; We have 3 registers in total. Register 0 is NaN. Register 1 is VAL. Register 2 is INF.
```

If you have some knowledge about the low-level CUDA assembly -- SASS, you may find the `MUFU.RCP` instruction is one of the key instruction for division operation.
It computes the reciprocal of register `R10` and stores the result in `R0`. 

Here, `GPU-FPX-ANA APPEAR` means there are no exceptional values (NaN, INF) are present in the source register `R10`, however, exceptional values occur in the destination `R0`
implying the apperance of an exception.

## [Benchmark](benchmarks/README.md)
We have benchmarked 151 GPU programs in our [paper](). To test and reproduce them, we refered to the [README.md](benchmarks/README.md) in the `benchmarks` folder.

## Contact
For questions, contact Ganesh Gopalakrishnan [ganesh@cs.utah.edu](mailto:ganesh@cs.utah.edu) and
 Xinyi Li [xin_yi.li@utah.edu](mailto:xin_yi.li@utah.edu).

To cite GPU-FPX please use
```
@
```


## License
GPU-FPX is distributed under the terms of the MIT license.

See [LICENSE-MIT](LICENSE), and [NOTICE](NOTICE) for details.

LLNL-CODE- 851480
