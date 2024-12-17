# .PHONY: NVBIT GPU-FPX 

all:analyzer detector

nvbit_version = 1.7.2

nvbit_tar=nvbit-Linux-x86_64-$(nvbit_version).tar.bz2
nvbit_tool=$(shell pwd)/nvbit_release/tools
GPUFPX_home=$(nvbit_tool)/GPU-FPX

analyzer: $(GPUFPX_home)/analyzer/analyzer.so
detector: $(GPUFPX_home)/detector/detector.so

$(GPUFPX_home)/analyzer/analyzer.so: $(GPUFPX_home)/analyzer/analyzer.cu
	cd $(GPUFPX_home)/analyzer; \
	$(MAKE)

$(GPUFPX_home)/analyzer/analyzer.cu: $(GPUFPX_home) $(GPUFPX_home)/utility/common.h
	cp -r $(nvbit_tool)/record_reg_vals/*.cu $</analyzer
	cp -r $(nvbit_tool)/record_reg_vals/Makefile $</analyzer
	cd $(GPUFPX_home)/analyzer && patch <analyzer.patch && patch <Makefile.patch && patch <inject_funcs.patch
	mv $(GPUFPX_home)/analyzer/record_reg_vals.cu $(GPUFPX_home)/analyzer/analyzer.cu

$(GPUFPX_home)/detector/detector.so: $(GPUFPX_home)/detector/detector.cu
	cd $(GPUFPX_home)/detector; \
	$(MAKE)

$(GPUFPX_home)/detector/detector.cu: $(GPUFPX_home) $(GPUFPX_home)/utility/common.h
	cp -r $(nvbit_tool)/record_reg_vals/*.cu $</detector
	cp -r $(nvbit_tool)/record_reg_vals/Makefile $</detector
	cd $(GPUFPX_home)/detector && patch <detector.patch && patch <Makefile.patch && patch <inject_funcs.patch
	mv $(GPUFPX_home)/detector/record_reg_vals.cu $(GPUFPX_home)/detector/detector.cu

$(GPUFPX_home)/utility/common.h:$(GPUFPX_home)
	cp $(nvbit_tool)/record_reg_vals/common.h $</utility
	cd $(GPUFPX_home)/utility && patch <common.patch

$(GPUFPX_home): nvbit_release
	cp -r GPU-FPX $(nvbit_tool)/

nvbit_release: $(nvbit_tar)
	tar -xf $<

$(nvbit_tar):
	wget https://github.com/NVlabs/NVBit/releases/download/v$(nvbit_version)/$@

clean:
	rm -rf nvbit_release/
	rm nvbit-Linux-x86_64-$(nvbit_version).tar.bz2
