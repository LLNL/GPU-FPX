
#NVCC=nvcc --generate-line-info
#NVCC=/usr/local/cuda-11.0/bin/nvcc --generate-line-info
# include ../../../../utility/config.mk

all: example1 example2

example1:
	nvcc --generate-line-info example1.cu -o example1

run-1:example1
	./example1

detect-1:example1
	LD_PRELOAD=../nvbit_release/tools/GPU-FPX/detector/detector.so ./example1

analyze-1:example1
	LD_PRELOAD=../nvbit_release/tools/GPU-FPX/analyzer//analyzer.so ./example1

example2:
	nvcc --generate-line-info example2.cu -o example2

run-2:example2
	./example2

detect-1:example2
	LD_PRELOAD=../nvbit_release/tools/GPU-FPX/detector/detector.so ./example2

analyze-1:example2
	LD_PRELOAD=../nvbit_release/tools/GPU-FPX/analyzer//analyzer.so ./example2

clean:
	rm -rf example1 example2
