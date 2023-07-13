FROM nvidia/cuda:10.2-devel-ubuntu18.04
WORKDIR /fpxbench
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC \
  && apt-get update \
  && apt-get install -y bc wget gcc time timelimit ssh
RUN wget http://developer.download.nvidia.com/compute/cuda/4_0/sdk/gpucomputingsdk_4.0.17_linux.run \
  && bash gpucomputingsdk_4.0.17_linux.run \
  && cd /root/NVIDIA_GPU_Computing_SDK/C \
  && make lib/libcutil.so 
RUN apt-get install -y python3-pip \
    && python3 -m pip install pandas vim
RUN apt-get install -y gfortran m4 zlib1g-dev libgl1-mesa-dev 
RUN apt-get install -y less bsdmainutils
VOLUME ./fpxbench/    
#VOLUME ./fpxbench/ /fpxbench/nvbit-exceptions/tools/GPU-FPX/ /fpxbench/nvbit-exceptions/tools/instr_count/ /fpxbench/nvbit-exceptions/tools/instr_count_fp/    
#COPY ./GPU-FPX ./GPU-FPX
#COPY ./instr_count_fp ./instr_count_fp
#COPY ./instr_count ./instr_count
#COPY ./fpxbench ./fpxbench
#COPY ./Makefile ./Makefile
#RUN make
