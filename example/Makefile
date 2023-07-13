
#NVCC=nvcc --generate-line-info
#NVCC=/usr/local/cuda-11.0/bin/nvcc --generate-line-info
# include ../../../../utility/config.mk

all: dot-prod

dot-prod:
	nvcc --generate-line-info dot-prod.cu -o dot-prod

run:dot-prod
	./dot-prod

detect:dot-prod
	LD_PRELOAD=../nvbit_release/tools/GPU-FPX/detector/detector.so ./dot-prod

analyze:dot-prod
	LD_PRELOAD=../nvbit_release/tools/GPU-FPX/analyzer//analyzer.so ./dot-prod

clean:
	rm -rf dot-prod
