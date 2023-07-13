all: parboil


setup: polybenchGpu gpu-rodinia parboil
compile: polybenchGpu

run: polybenchGpu_exps

rodinia_tar:=rodinia_3.1.tar.bz2
rodinia_base:=$(basename $(basename $(rodinia_tar)))

polybenchGpu_exps: polybenchGpu
	cd polybenchGpu/CUDA && bash comp_run_all.sh

GPGPUSIM:

polybenchGpu:
	git clone https://github.com/sgrauerg/polybenchGpu.git
	cd polybenchGpu/CUDA && patch -p2 <../../polybenchGpu.patch

gpu-rodinia: $(rodinia_base)
	mv $< $@
	cd gpu-rodinia/cuda && rm -rf pathfinder particlefilter mummergpu \
		&& patch -p2 <../../gpu-rodinia.patch
	cd gpu-rodinia/common &&  patch -p2 <../../gpu-rodinia-common.patch

$(rodinia_base): $(rodinia_tar)
	tar xvfj $<

$(rodinia_tar):
	wget http://www.cs.virginia.edu/~skadron/lava/Rodinia/Packages/$@

parboil:
	git clone https://github.com/abduld/Parboil.git

clean:
	rm -rf polybenchGpu gpu-rodinia
