sudo docker run --name cu-sa-2 --gpus all -it \
  -v /home/xinyi/nvbit-exceptions/tools/GPU-FPX/:/cuda-examples/GPU-FPX/ \
  -v /home/xinyi/nvbit-exceptions/tools/GPU-FPX-ana/:/cuda-examples/GPU-FPX-ana/ \
  -v /home/xinyi/nvbit-exceptions/tools/instr_count_fp/:/cuda-examples/instr_count_fp/ \
  -v /home/xinyi/nvbit-exceptions/tools/instr_count/:/cuda-examples/instr_count/ \
  -v /home/xinyi/nvbit-exceptions/tools/detect_fp_exceptions_ori/:/cuda-examples/detect_fp_exceptions_ori/ \
  -v "$(pwd)"/cuda-samples:/cuda-examples/cuda-samples \
  -v /home/xinyi/experiments_gpuchecker/exps_docker/Makefile_cuda-samples:/cuda-examples/Makefile cuda-samples bash

